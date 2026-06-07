const API_URL = '/todos';

async function fetchTodos() {
    try {
        const res = await fetch(API_URL);
        const todos = await res.json();
        renderTodos(todos);
    } catch (e) {
        console.error('목록 불러오기 실패:', e);
    }
}

async function addTodo() {
    const input = document.getElementById('todoInput');
    const title = input.value.trim();
    if (!title) return;

    try {
        await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title })
        });
        input.value = '';
        fetchTodos();
    } catch (e) {
        console.error('추가 실패:', e);
    }
}

async function completeTodo(id) {
    try {
        await fetch(`${API_URL}/${id}/complete`, { method: 'PATCH' });
        fetchTodos();
    } catch (e) {
        console.error('완료 처리 실패:', e);
    }
}

async function deleteTodo(id) {
    try {
        await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
        fetchTodos();
    } catch (e) {
        console.error('삭제 실패:', e);
    }
}

function renderTodos(todos) {
    const list = document.getElementById('todoList');
    document.getElementById('total').textContent = todos.length;
    document.getElementById('completedCount').textContent = todos.filter(t => t.completed).length;

    if (todos.length === 0) {
        list.innerHTML = '<div class="empty-state">할 일이 없어요.<br>새로운 할 일을 추가해보세요!</div>';
        return;
    }

    list.innerHTML = todos.map(todo => `
        <li class="todo-item ${todo.completed ? 'completed' : ''}">
            <span class="todo-title">${escapeHtml(todo.title)}</span>
            <button class="btn-complete" onclick="completeTodo(${todo.id})" ${todo.completed ? 'disabled' : ''}>
                ${todo.completed ? '완료됨' : '완료'}
            </button>
            <button class="btn-delete" onclick="deleteTodo(${todo.id})">삭제</button>
        </li>
    `).join('');
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
}

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('todoInput').addEventListener('keypress', e => {
        if (e.key === 'Enter') addTodo();
    });
    fetchTodos();
});