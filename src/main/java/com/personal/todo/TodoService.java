package com.personal.todo;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class TodoService {

    private final TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository){
        this.todoRepository = todoRepository;
    }

    // 추가
    public Todo addTodo(String title){
        Todo todo = new Todo();
        todo.setTitle(title);
        todo.setCompleted(false);
        todo.setCreatedAt(LocalDateTime.now());

        return todoRepository.save(todo);
    }

    // 목록 전체 조회
    public List<Todo> getAllTodos(){
        return todoRepository.findAll();
    }

    // 완료 처리
    public Todo completeTodo(Long id){
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo를 찾을 수 없습니다."));
        todo.setCompleted(true);

        return todoRepository.save(todo);
    }

    // 삭제
    public void deleteTodo(Long id){
        todoRepository.deleteById(id);
    }
}
