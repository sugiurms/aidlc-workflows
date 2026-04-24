#!/usr/bin/env bash
# AIDLC 日本語スキルをビルドしてインストールする
# 使用法: ./scripts/install.sh [--project <dest> | --user | --build-only | --clean]
#   --user           : ユーザーレベル (~/.claude/skills/aidlc/) にインストール（デフォルト）
#   --project <dest> : 指定したプロジェクトディレクトリにインストール (<dest>/.claude/skills/aidlc/)
#   --build-only     : ビルドのみ実行し、インストールはしない (dist/aidlc/ に出力)
#   --clean          : 中間生成物 (dist/aidlc/) を削除する

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RULES_DIR="${REPO_ROOT}/aidlc-rules"
DETAILS_SRC="${RULES_DIR}/aws-aidlc-rule-details"
SKILL_SRC="${REPO_ROOT}/skill/aidlc"
BUILD_DIR="${REPO_ROOT}/dist/aidlc"

build() {
    rm -rf "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}/references/aws-aidlc-rule-details"

    # 1. SKILL.md をコピー
    cp "${SKILL_SRC}/SKILL.md" "${BUILD_DIR}/SKILL.md"

    # 2. skill/aidlc/references/ 配下のファイルをコピー（存在する場合のみ）
    if [ -d "${SKILL_SRC}/references" ]; then
        cp -r "${SKILL_SRC}/references/." "${BUILD_DIR}/references/"
    fi

    # 3. 日本語ルール詳細ファイルをコピー（.ja をファイル名から除去）
    find "${DETAILS_SRC}" -name "*.ja.md" | while read -r src; do
        rel="${src#${DETAILS_SRC}/}"       # 例: common/process-overview.ja.md
        dest="${rel%.ja.md}.md"            # 例: common/process-overview.md
        mkdir -p "${BUILD_DIR}/references/aws-aidlc-rule-details/$(dirname "${dest}")"
        cp "${src}" "${BUILD_DIR}/references/aws-aidlc-rule-details/${dest}"
    done

    VERSION=$(cat "${RULES_DIR}/VERSION")
    FILE_COUNT=$(find "${BUILD_DIR}" -name "*.md" | wc -l)
    echo "aidlc(ja) スキル v${VERSION} をビルドしました: ${BUILD_DIR} (${FILE_COUNT} ファイル)"
}

clean() {
    if [ -d "${BUILD_DIR}" ]; then
        rm -rf "${BUILD_DIR}"
        echo "中間生成物を削除しました: ${BUILD_DIR}"
    else
        echo "中間生成物はありません: ${BUILD_DIR}"
    fi
}

install() {
    local dest="$1"

    rm -rf "${dest}"
    mkdir -p "$(dirname "${dest}")"
    cp -r "${BUILD_DIR}" "${dest}"

    VERSION=$(cat "${RULES_DIR}/VERSION")
    echo "aidlc(ja) スキル v${VERSION} を ${dest} にインストールしました"
    echo ""
    echo "使い方: Claude Code で /aidlc <プロジェクトの説明> を実行してください"
}

MODE="${1:---user}"

case "${MODE}" in
    --build-only)
        build
        exit 0
        ;;
    --clean)
        clean
        exit 0
        ;;
    --user)
        DEST="${HOME}/.claude/skills/aidlc"
        ;;
    --project)
        if [ -z "${2:-}" ]; then
            echo "エラー: --project にはインストール先ディレクトリを指定してください" >&2
            echo "使用法: $0 --project <dest>" >&2
            exit 1
        fi
        DEST="${2}/.claude/skills/aidlc"
        ;;
    *)
        echo "使用法: $0 [--project <dest> | --user | --build-only | --clean]" >&2
        echo "  --user           : ユーザーレベルにインストール（デフォルト）" >&2
        echo "  --project <dest> : 指定したプロジェクトにインストール" >&2
        echo "  --build-only     : ビルドのみ実行（インストールしない）" >&2
        echo "  --clean          : 中間生成物を削除" >&2
        exit 1
        ;;
esac

build > /dev/null
install "${DEST}"
