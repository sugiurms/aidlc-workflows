#!/usr/bin/env bash
# AIDLC 日本語スキルをインストールする
# 使用法: ./scripts/install-skill.sh [--project <dest> | --user]
#   --user           : ユーザーレベル (~/.claude/skills/aidlc-ja/) にインストール（デフォルト）
#   --project <dest> : 指定したプロジェクトディレクトリにインストール (<dest>/.claude/skills/aidlc-ja/)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:---user}"

# まずビルド
"${REPO_ROOT}/scripts/build-skill.sh" > /dev/null

case "${MODE}" in
    --user)
        DEST="${HOME}/.claude/skills/aidlc-ja"
        ;;
    --project)
        if [ -z "${2:-}" ]; then
            echo "エラー: --project にはインストール先ディレクトリを指定してください" >&2
            echo "使用法: $0 --project <dest>" >&2
            exit 1
        fi
        DEST="${2}/.claude/skills/aidlc-ja"
        ;;
    *)
        echo "使用法: $0 [--project <dest> | --user]" >&2
        echo "  --user           : ユーザーレベルにインストール（デフォルト）" >&2
        echo "  --project <dest> : 指定したプロジェクトにインストール" >&2
        exit 1
        ;;
esac

rm -rf "${DEST}"
mkdir -p "$(dirname "${DEST}")"
cp -r "${REPO_ROOT}/dist/aidlc-ja" "${DEST}"

VERSION=$(cat "${REPO_ROOT}/aidlc-rules/VERSION")
echo "aidlc-ja スキル v${VERSION} を ${DEST} にインストールしました"
echo ""
echo "使い方: Claude Code で /aidlc <プロジェクトの説明> を実行してください"
