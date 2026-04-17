#!/usr/bin/env bash
# AIDLC 日本語スキルをリポジトリソースからビルドする
# 使用法: ./scripts/build-skill.sh [出力ディレクトリ]
#   デフォルト出力: ./dist/aidlc/

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RULES_DIR="${REPO_ROOT}/aidlc-rules"
DETAILS_SRC="${RULES_DIR}/aws-aidlc-rule-details"
SKILL_SRC="${REPO_ROOT}/skill/aidlc"

OUTPUT_DIR="${1:-${REPO_ROOT}/dist/aidlc}"

# クリーンアップと出力ディレクトリ作成
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/references/aws-aidlc-rule-details"

# 1. SKILL.md をコピー
cp "${SKILL_SRC}/SKILL.md" "${OUTPUT_DIR}/SKILL.md"

# 2. 日本語ルール詳細ファイルをコピー（.ja をファイル名から除去）
find "${DETAILS_SRC}" -name "*.ja.md" | while read -r src; do
    rel="${src#${DETAILS_SRC}/}"       # 例: common/process-overview.ja.md
    dest="${rel%.ja.md}.md"            # 例: common/process-overview.md
    mkdir -p "${OUTPUT_DIR}/references/aws-aidlc-rule-details/$(dirname "${dest}")"
    cp "${src}" "${OUTPUT_DIR}/references/aws-aidlc-rule-details/${dest}"
done

VERSION=$(cat "${RULES_DIR}/VERSION")
FILE_COUNT=$(find "${OUTPUT_DIR}" -name "*.md" | wc -l)
echo "aidlc(ja) スキル v${VERSION} をビルドしました: ${OUTPUT_DIR} (${FILE_COUNT} ファイル)"
