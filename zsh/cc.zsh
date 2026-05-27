alias cc=claude

export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export DISABLE_ERROR_REPORTING=1
export DISABLE_TELEMETRY=1
export MCP_TIMEOUT=60000

claude() {
    ANTHROPIC_BASE_URL=http://localhost:3000 \
    ANTHROPIC_AUTH_TOKEN="12345678" \
    command claude "$@"
}

cc-deepseek() {
    ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic \
    ANTHROPIC_AUTH_TOKEN="$DEEPSEEK_AUTH_TOKEN" \
    ANTHROPIC_MODEL="deepseek-v4-pro[1m]" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro[1m]" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro[1m]" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash \
    CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash \
    CLAUDE_CODE_EFFORT_LEVEL=max \
    command claude "$@"
}

cc-glm-5.1() {
    ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic \
    ANTHROPIC_AUTH_TOKEN="$GLM_AUTH_TOKEN" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.5-Air \
    ANTHROPIC_DEFAULT_OPUS_MODEL=glm-5.1 \
    ANTHROPIC_DEFAULT_SONNET_MODEL=glm-5-turbo \
    ANTHROPIC_MODEL=glm-5.1 \
    command claude "$@"
}

cc-glm() {
    ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic \
    ANTHROPIC_AUTH_TOKEN="$GLM_AUTH_TOKEN" \
    command claude "$@"
}

