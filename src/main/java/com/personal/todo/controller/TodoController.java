package com.personal.todo.controller;

import com.personal.todo.entity.Todo;
import com.personal.todo.service.TodoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/todos")
public class TodoController {

    private final TodoService todoService;

    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    // 추가 POST
    @PostMapping
    public Todo addTodo(@RequestBody Map<String, String> body){
        return todoService.addTodo(body.get("title"));
    }

    // 목록 전체 조회 GET
    @GetMapping
    public List<Todo> getAllTodos(){
        return todoService.getAllTodos();
    }


    // 완료 처리 PATCH
    @PatchMapping("/{id}/complete")
    public Todo completeTodo(@PathVariable Long id){
        return todoService.completeTodo(id);
    }

    // 삭제 DELETE
    @DeleteMapping("/{id}")
    public void deleteTodo(@PathVariable Long id){
        todoService.deleteTodo(id);
    }
}
