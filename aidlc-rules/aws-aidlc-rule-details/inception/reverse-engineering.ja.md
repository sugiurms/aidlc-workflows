# リバースエンジニアリング

**目的**: 既存のコードベースを分析し、包括的な設計アーティファクトを生成する

**実行するタイミング**: ブラウンフィールドプロジェクトが検出された場合（ワークスペースに既存のコードがある場合）

**スキップするタイミング**: グリーンフィールドプロジェクト（既存のコードがない場合）

**再実行の動作**: 再実行は workspace-detection.md によって制御される。既存のリバースエンジニアリングアーティファクトが見つかりまだ有効な場合は、それらを読み込みリバースエンジニアリングはスキップされる。アーティファクトが古い（コードベースの最後の重要な変更よりも古い）か、ユーザーが明示的に再実行を要求した場合、アーティファクトが現在のコード状態を反映するように再度リバースエンジニアリングが実行される

## ステップ 1: マルチパッケージの探索

### 1.1 ワークスペースのスキャン
- すべてのパッケージ（言及されたものだけでなく）
- 設定ファイルを経由したパッケージの関係
- パッケージのタイプ: アプリケーション、CDK/インフラストラクチャ、モデル、クライアント、テスト

### 1.2 ビジネスコンテキストの理解
- システムが全体として実装しているコアビジネス
- すべてのパッケージのビジネス概要
- システムで実装されているビジネストランザクションのリスト

### 1.3 インフラストラクチャの探索
- CDK パッケージ（CDK 依存関係のある package.json）
- Terraform（.tf ファイル）
- CloudFormation（.yaml/.json テンプレート）
- デプロイスクリプト

### 1.4 ビルドシステムの探索
- ビルドシステム: Brazil、Maven、Gradle、npm
- ビルドシステム宣言のための設定ファイル
- パッケージ間のビルド依存関係

### 1.5 サービスアーキテクチャの探索
- Lambda 関数（ハンドラー、トリガー）
- コンテナサービス（Docker/ECS 設定）
- API 定義（Smithy モデル、OpenAPI 仕様）
- データストア（DynamoDB、S3 など）

### 1.6 コード品質の分析
- プログラミング言語とフレームワーク
- テストカバレッジの指標
- リント設定
- CI/CD パイプライン

## ステップ 2: ビジネス概要ドキュメントの生成

`aidlc-docs/inception/reverse-engineering/business-overview.md` を作成する:

```markdown
# Business Overview

## Business Context Diagram
[ビジネスコンテキストを示す Mermaid 図]

## Business Description
- **Business Description**: [システムが何をするかの全体的なビジネス説明]
- **Business Transactions**: [システムが実装するビジネストランザクションとその説明のリスト]
- **Business Dictionary**: [システムが従うビジネス辞書の用語とその意味]

## Component Level Business Descriptions
### [パッケージ/コンポーネント名]
- **Purpose**: [ビジネス観点からの目的]
- **Responsibilities**: [主要な責務]
```

## ステップ 3: アーキテクチャドキュメントの生成

`aidlc-docs/inception/reverse-engineering/architecture.md` を作成する:

```markdown
# System Architecture

## System Overview
[システムの高レベルの説明]

## Architecture Diagram
[すべてのパッケージ、サービス、データストア、関係を示す Mermaid 図]

## Component Descriptions
### [パッケージ/コンポーネント名]
- **Purpose**: [何をするか]
- **Responsibilities**: [主要な責務]
- **Dependencies**: [依存するもの]
- **Type**: [Application/Infrastructure/Model/Client/Test]

## Data Flow
[主要なワークフローの Mermaid シーケンス図]

## Integration Points
- **External APIs**: [目的とともにリスト]
- **Databases**: [目的とともにリスト]
- **Third-party Services**: [目的とともにリスト]

## Infrastructure Components
- **CDK Stacks**: [目的とともにリスト]
- **Deployment Model**: [説明]
- **Networking**: [VPC、サブネット、セキュリティグループ]
```

## ステップ 4: コード構造ドキュメントの生成

`aidlc-docs/inception/reverse-engineering/code-structure.md` を作成する:

```markdown
# Code Structure

## Build System
- **Type**: [Maven/Gradle/npm/Brazil]
- **Configuration**: [主要なビルドファイルと設定]

## Key Classes/Modules
[Mermaid クラス図またはモジュール階層]

### Existing Files Inventory
[すべてのソースファイルとその目的をリストする — これらはブラウンフィールドプロジェクトで変更の候補]

**形式の例**:
- `[path/to/file]` - [目的/責務]

## Design Patterns
### [パターン名]
- **Location**: [使用場所]
- **Purpose**: [使用理由]
- **Implementation**: [実装方法]

## Critical Dependencies
### [依存関係名]
- **Version**: [バージョン番号]
- **Usage**: [使用方法と場所]
- **Purpose**: [必要な理由]
```

## ステップ 5: API ドキュメントの生成

`aidlc-docs/inception/reverse-engineering/api-documentation.md` を作成する:

```markdown
# API Documentation

## REST APIs
### [エンドポイント名]
- **Method**: [GET/POST/PUT/DELETE]
- **Path**: [/api/path]
- **Purpose**: [何をするか]
- **Request**: [リクエストフォーマット]
- **Response**: [レスポンスフォーマット]

## Internal APIs
### [インターフェース/クラス名]
- **Methods**: [シグネチャとともにリスト]
- **Parameters**: [パラメーターの説明]
- **Return Types**: [戻り値の型の説明]

## Data Models
### [モデル名]
- **Fields**: [フィールドの説明]
- **Relationships**: [関連モデル]
- **Validation**: [バリデーションルール]
```

## ステップ 6: コンポーネントインベントリの生成

`aidlc-docs/inception/reverse-engineering/component-inventory.md` を作成する:

```markdown
# Component Inventory

## Application Packages
- [パッケージ名] - [目的]

## Infrastructure Packages
- [パッケージ名] - [CDK/Terraform] - [目的]

## Shared Packages
- [パッケージ名] - [Models/Utilities/Clients] - [目的]

## Test Packages
- [パッケージ名] - [Integration/Load/Unit] - [目的]

## Total Count
- **Total Packages**: [数]
- **Application**: [数]
- **Infrastructure**: [数]
- **Shared**: [数]
- **Test**: [数]
```

## ステップ 7: 技術スタックドキュメントの生成

`aidlc-docs/inception/reverse-engineering/technology-stack.md` を作成する:

```markdown
# Technology Stack

## Programming Languages
- [言語] - [バージョン] - [使用方法]

## Frameworks
- [フレームワーク] - [バージョン] - [目的]

## Infrastructure
- [サービス] - [目的]

## Build Tools
- [ツール] - [バージョン] - [目的]

## Testing Tools
- [ツール] - [バージョン] - [目的]
```

## ステップ 8: 依存関係ドキュメントの生成

`aidlc-docs/inception/reverse-engineering/dependencies.md` を作成する:

```markdown
# Dependencies

## Internal Dependencies
[パッケージの依存関係を示す Mermaid 図]

### [パッケージ A] は [パッケージ B] に依存する
- **Type**: [Compile/Runtime/Test]
- **Reason**: [依存関係が存在する理由]

## External Dependencies
### [依存関係名]
- **Version**: [バージョン]
- **Purpose**: [使用理由]
- **License**: [ライセンスタイプ]
```

## ステップ 9: コード品質評価の生成

`aidlc-docs/inception/reverse-engineering/code-quality-assessment.md` を作成する:

```markdown
# Code Quality Assessment

## Test Coverage
- **Overall**: [パーセンテージまたは Good/Fair/Poor/None]
- **Unit Tests**: [ステータス]
- **Integration Tests**: [ステータス]

## Code Quality Indicators
- **Linting**: [Configured/Not configured]
- **Code Style**: [Consistent/Inconsistent]
- **Documentation**: [Good/Fair/Poor]

## Technical Debt
- [問題の説明と場所]

## Patterns and Anti-patterns
- **Good Patterns**: [リスト]
- **Anti-patterns**: [場所とともにリスト]
```

## ステップ 10: タイムスタンプファイルの作成

`aidlc-docs/inception/reverse-engineering/reverse-engineering-timestamp.md` を作成する:

```markdown
# Reverse Engineering Metadata

**Analysis Date**: [ISO タイムスタンプ]
**Analyzer**: AI-DLC
**Workspace**: [ワークスペースのパス]
**Total Files Analyzed**: [数]

## Artifacts Generated
- [x] architecture.md
- [x] code-structure.md
- [x] api-documentation.md
- [x] component-inventory.md
- [x] technology-stack.md
- [x] dependencies.md
- [x] code-quality-assessment.md
```

## ステップ 11: 状態トラッキングの更新

`aidlc-docs/aidlc-state.md` を更新する:

```markdown
## Reverse Engineering Status
- [x] Reverse Engineering - Completed on [タイムスタンプ]
- **Artifacts Location**: aidlc-docs/inception/reverse-engineering/
```

## ステップ 12: 完了メッセージのユーザーへの提示

```markdown
# 🔍 Reverse Engineering Complete

[分析から得られた主要な発見の AI 生成サマリー（箇条書き）]

> **📋 <u>**REVIEW REQUIRED:**</u>**
> Please examine the reverse engineering artifacts at: `aidlc-docs/inception/reverse-engineering/`

> **🚀 <u>**WHAT'S NEXT?**</u>**
>
> **You may:**
>
> 🔧 **Request Changes** - Ask for modifications to the reverse engineering analysis if required
> ✅ **Approve & Continue** - Approve analysis and proceed to **Requirements Analysis**
```

## ステップ 13: ユーザーの承認を待機する

- **必須**: ユーザーが明示的に承認するまで進行しない
- **必須**: ユーザーの応答（完全な生の入力を含む）を audit.md にログ記録する
