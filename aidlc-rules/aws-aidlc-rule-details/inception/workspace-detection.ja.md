# ワークスペース検出

**目的**: ワークスペースの状態を確認し、既存の AI-DLC プロジェクトをチェックする

## ステップ 1: 既存の AI-DLC プロジェクトの確認

`aidlc-docs/aidlc-state.md` が存在するかどうかを確認する:
- **存在する場合**: 最後のフェーズから再開する（前のフェーズからコンテキストを読み込む）
- **存在しない場合**: 新しいプロジェクト評価を続行する

## ステップ 2: 既存のコードについてワークスペースをスキャンする

**ワークスペースに既存のコードがあるかどうかを確認する:**
- ソースコードファイルのワークスペースをスキャンする（.java、.py、.js、.ts、.jsx、.tsx、.kt、.kts、.scala、.groovy、.go、.rs、.rb、.php、.c、.h、.cpp、.hpp、.cc、.cs、.fs など）
- ビルドファイルを確認する（pom.xml、package.json、build.gradle など）
- プロジェクト構造の指標を探す
- ワークスペースのルートディレクトリを特定する（aidlc-docs/ ではない）

**調査結果を記録する:**
```markdown
## Workspace State
- **Existing Code**: [Yes/No]
- **Programming Languages**: [見つかった場合はリスト]
- **Build System**: [Maven/Gradle/npm/など（見つかった場合）]
- **Project Structure**: [Monolith/Microservices/Library/Empty]
- **Workspace Root**: [絶対パス]
```

## ステップ 3: 次のフェーズの決定

**ワークスペースが空の場合（既存のコードなし）**:
- フラグを設定する: `brownfield = false`
- 次のフェーズ: 要件分析

**ワークスペースに既存のコードがある場合**:
- フラグを設定する: `brownfield = true`
- `aidlc-docs/inception/reverse-engineering/` に既存のリバースエンジニアリングアーティファクトがあるかどうかを確認する
- **リバースエンジニアリングアーティファクトが存在する場合**:
    - アーティファクトが古いかどうかを確認する（アーティファクトのタイムスタンプをコードベースの最後の重要な変更と比較する）
    - **アーティファクトが最新の場合**: それらを読み込み、要件分析にスキップする
    - **アーティファクトが古い場合**: 次のフェーズはリバースエンジニアリング（アーティファクトを更新するために再実行）
    - **ユーザーが明示的に再実行を要求した場合**: 古さに関係なく次のフェーズはリバースエンジニアリング
- **リバースエンジニアリングアーティファクトがない場合**: 次のフェーズはリバースエンジニアリング

## ステップ 4: 初期状態ファイルの作成

`aidlc-docs/aidlc-state.md` を作成する:

```markdown
# AI-DLC State Tracking

## Project Information
- **Project Type**: [Greenfield/Brownfield]
- **Start Date**: [ISO タイムスタンプ]
- **Current Stage**: INCEPTION - Workspace Detection

## Workspace State
- **Existing Code**: [Yes/No]
- **Reverse Engineering Needed**: [Yes/No]
- **Workspace Root**: [絶対パス]

## Code Location Rules
- **Application Code**: ワークスペースルート（aidlc-docs/ の中に置かない）
- **Documentation**: aidlc-docs/ のみ
- **Structure patterns**: code-generation.md のクリティカルルールを参照

## Stage Progress
[ワークフローの進行に伴って記録される]
```

## ステップ 5: 完了メッセージの提示

**ブラウンフィールドプロジェクトの場合:**
```markdown
# 🔍 Workspace Detection Complete

Workspace analysis findings:
• **Project Type**: Brownfield project
• [ワークスペースの調査結果の AI 生成サマリー（箇条書き）]
• **Next Step**: Proceeding to **Reverse Engineering** to analyze existing codebase...
```

**グリーンフィールドプロジェクトの場合:**
```markdown
# 🔍 Workspace Detection Complete

Workspace analysis findings:
• **Project Type**: Greenfield project
• **Next Step**: Proceeding to **Requirements Analysis**...
```

## ステップ 6: 自動進行

- **ユーザーの承認は不要** — これは情報提供のみ
- 次のフェーズに自動的に進む:
  - **ブラウンフィールド**: リバースエンジニアリング（既存のアーティファクトがない場合）または要件分析（アーティファクトが存在する場合）
  - **グリーンフィールド**: 要件分析
