# todo-app

## Project Overview

개인 학습용 할 일 관리 백엔드 프로젝트.

- Java 17
- Spring Boot 4.0.6
- H2 (현재) → MySQL 전환 예정 (#9)
- Spring Data JPA
- Lombok
- Thymeleaf

## Development Commands

```bash
# 실행
./gradlew bootRun

# 테스트
./gradlew test

# 특정 테스트
./gradlew test --tests TodoServiceTest

# 빌드
./gradlew clean build
```

## Project Structure

```
src/main/java/com/personal/todo/
├── controller/     # HTTP 요청 처리
├── entity/         # JPA 엔티티
├── repository/     # 데이터 접근
└── service/        # 비즈니스 로직
```

## Coding Conventions

### Entity

- Setter 사용 금지
- 생성 메서드(create) 또는 Builder 사용
- Lombok `@Builder`, `@NoArgsConstructor(access = PROTECTED)` 패턴 권장

### Service

- 비즈니스 로직은 Service에만 작성
- Controller에서 로직 처리 금지
- `@Transactional` 은 Service 계층에서만 사용

### Repository

- Spring Data JPA 기본 메서드 우선 사용
- 복잡한 쿼리는 JPQL, Native Query 사용 전 검토 필요

## API Rules

- `ResponseEntity` 사용
- 향후 `ApiResponse` 래퍼 클래스 도입 예정 (#7)

## Architecture Decisions

- **DB**: H2 → MySQL 전환 예정. 현재 H2 기준으로 개발 (#9)
- **예외 처리**: 전역 예외 처리 고도화 예정 (#5)
- **DTO**: 도입 예정 — 현재 Entity 직접 사용 중 (#6)

## Testing Rules

- Service 계층 단위 테스트 필수
- Repository 테스트는 복잡한 쿼리만 작성
- Controller 테스트는 슬라이스 테스트(`@WebMvcTest`) 사용

## AI Instructions

### Always

- 기존 코드 스타일을 따라라
- 새 라이브러리 추가 전 이유를 먼저 설명하라
- 코드 수정 전 관련 파일을 먼저 읽어라

### Never

- 추측으로 구현하지 마라 — 불명확하면 질문하라
- 요청받지 않은 파일을 수정하지 마라
- `application.properties` / `application.yml` 수정 금지 (변경 필요 시 먼저 확인)
- Setter를 Entity에 추가하지 마라

### When Unsure

확신이 80% 미만이면 코드를 작성하지 말고 질문하라.

## Collaboration Rules

- **학습 방식**: 코드 전체를 생성하지 말고 개념 설명 → 힌트 → 직접 구현 순서로 유도 (프론트엔드 제외)
- **커밋 규칙**: 커밋 메시지에 Claude/Anthropic 관련 정보(Co-Authored-By 등) 절대 포함하지 않음

## Session Management

새 대화가 시작되면 반드시:

1. `docs/sessions/` 폴더에서 가장 최근 파일(이름 기준 마지막 파일)을 읽는다
2. 이전 Git 상태, 열린 이슈, 작업 맥락을 파악한다
3. 사용자에게 2-3줄로 "지난 세션 요약 + 이어서 할 수 있는 작업"을 먼저 말한다

세션 인수인계 스크립트: `.claude/generate-handoff.ps1`
커밋 가이드: `.claude/generate-handoff.ps1` 하단 Git 커밋 가이드 섹션 참고