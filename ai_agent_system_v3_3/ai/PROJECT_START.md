# PROJECT_START.md — v3.0
# 새 세션 시작 시 에이전트가 수행하는 초기화 절차

## 자동 로드 순서

Cline은 세션 시작 시 .clinerules를 자동으로 읽습니다.
추가로 에이전트는 다음 순서로 파일을 확인합니다:

```
1. .clinerules              → 핵심 규칙 (Cline 자동 로드)
2. ai/Context_Profile.md   → 현재 모드 확인 (WORK/HOBBY)
3. ai/Core_System.md       → 상태 머신 확인
4. ai/Risk_Matrix.md       → Risk 판정 기준 숙지
```

## 환경 점검

```
[ ] .ai_checkpoints/ 폴더 존재 확인
[ ] WORK_LOG.md 크기 확인 (50KB 초과 시 아카이브)
[ ] 미완료 CHECKPOINT 존재 확인 (있으면 사용자에게 보고)
[ ] ai/scripts/ 폴더 및 스크립트 존재 확인
```

## 세션 시작 선언

```
[READY — v3.0 | {WORK/HOBBY}]
- 미완료 작업: {있으면 목록, 없으면 "없음"}
- 준비 완료. 지시를 기다립니다.
```

## 미완료 작업 발견 시

.ai_checkpoints/ 에서 status: PENDING 또는 FAILED 발견 시:

1. 목록을 사용자에게 보고
2. "이어서 진행할까요, 무시할까요?" 한 번만 질문
3. 이어서 → 해당 CHECKPOINT.md의 복구 절차 실행
4. 무시 → ABANDONED로 표시하고 계속

## WORK_LOG 아카이브 규칙

- WORK_LOG.md 크기 50KB 초과 시:
  - bash ai/scripts/archive_log.sh 실행  (Mac Terminal / 회사 Git Bash 공통)
  - 현재 로그 → .ai_checkpoints/archive/WORK_LOG_YYYYMMDD.md 로 이동
  - 새 WORK_LOG.md 시작 (상단에 "이전 로그: archive/" 링크 포함)
- 아카이브 파일은 삭제하지 않음 (감사 목적)
