# Todo App

Spring Boot 기반의 할 일 관리 웹 애플리케이션입니다.

---

## 기술 스택

### Backend
| 기술 | 버전 |
|------|------|
| Java | 17.0.10 |
| Spring Boot | 4.0.6 |
| Spring Data JPA | Spring Boot 관리 |
| Hibernate ORM | 7.2.12.Final |
| H2 Database | 2.4.240 |
| Lombok | Spring Boot 관리 |
| Gradle | Wrapper 사용 |

### Frontend
| 기술 | 버전 |
|------|------|
| HTML5 | - |
| CSS3 | - |
| Vanilla JavaScript | ES2017+ |

### 개발 환경
| 도구 | 버전 |
|------|------|
| IntelliJ IDEA | - |
| Postman | - |

---

## 프로젝트 구조

```
src/
├── main/
│   ├── java/com/personal/todo/
│   │   ├── TodoApplication.java      # 앱 진입점
│   │   ├── Todo.java                 # Entity
│   │   ├── TodoRepository.java       # JPA Repository
│   │   ├── TodoService.java          # 비즈니스 로직
│   │   └── TodoController.java       # REST API
│   └── resources/
│       ├── static/
│       │   ├── index.html            # 메인 화면
│       │   ├── style.css             # 스타일 (Glassmorphism)
│       │   └── app.js                # API 연동 스크립트
│       └── application.properties   # 설정 파일
```

---

## API 명세

| 기능 | Method | URL | Request Body |
|------|--------|-----|--------------|
| 할 일 추가 | POST | `/todos` | `{ "title": "내용" }` |
| 목록 조회 | GET | `/todos` | - |
| 완료 처리 | PATCH | `/todos/{id}/complete` | - |
| 삭제 | DELETE | `/todos/{id}` | - |

---

## 실행 방법

```bash
./gradlew bootRun
```

실행 후 브라우저에서 접속: `http://localhost:8080`

---

## 주요 기능

- 할 일 추가 (Enter 키 또는 추가 버튼)
- 전체 목록 조회
- 완료 처리 (완료된 항목 취소선 표시)
- 삭제
- 전체 / 완료 카운트 표시
- 반응형 레이아웃 (모바일 지원)

---

## 보완할 사항

- [ ] 입력값 유효성 검사 (빈 문자열, 최대 길이 제한)
- [ ] 완료 처리 취소 기능 (toggle 방식으로 변경)
- [ ] 예외 처리 고도화 (Custom Exception, 에러 응답 포맷 통일)
- [ ] DTO 도입 (Entity 직접 노출 대신 Request/Response DTO 분리)
- [ ] API 응답 포맷 통일 (공통 Response 래퍼 클래스)
- [ ] 패키지 구조 분리 (controller / service / repository / entity)
- [ ] H2 → MySQL 또는 PostgreSQL 전환

---

## 확장 예정

- [ ] 할 일 수정 기능 (제목 편집)
- [ ] 마감일(dueDate) 필드 추가 및 D-day 표시
- [ ] 카테고리 / 태그 분류 기능
- [ ] 우선순위 설정 (높음 / 보통 / 낮음)
- [ ] 필터 기능 (전체 / 진행 중 / 완료)
- [ ] 회원가입 / 로그인 (Spring Security + JWT)
- [ ] 사용자별 Todo 관리 (멀티 유저 지원)