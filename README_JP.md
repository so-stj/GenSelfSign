# GeneSelfSign PowerShell スクリプト

スクリプトや実行ファイルにコード署名を適用するための自己署名証明書を生成するPowerShellスクリプトです。

## 説明

このスクリプトは自己署名コード署名証明書を作成し、指定されたファイルやディレクトリに適用します。PowerShellスクリプトやその他の実行ファイルを信頼された証明書で署名する必要がある開発、自動化とテストを行う際に役立ちます。

## 機能

- RSA 4096ビット暗号化による自己署名コード署名証明書の作成
- 証明書を信頼されたルートストアに自動的に移動
- 指定されたターゲットにAuthenticode署名を適用
- 2099年1月1日まで有効な証明書

## 前提条件

- Windows PowerShell 5.1またはPowerShell Core 6.0+
- 証明書操作のための管理者権限
- スクリプト実行を許可する実行ポリシー

## 使用方法

```powershell
.\GeneSelfSign.ps1 -Description "証明書の説明" -ScriptFile "path\to\your\script.ps1"
```

## パラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|------|----------|-------------|
| `Description` | String | はい | 証明書の説明名（例：「MyApp開発証明書」） |
| `ScriptFile` | String | はい | 署名したいファイルやディレクトリのパス |

## 例

### PowerShellスクリプトに署名
```powershell
.\GeneSelfSign.ps1 -Description "MyApp開発証明書" -ScriptFile "C:\Scripts\MyScript.ps1"
```

### 実行ファイルに署名
```powershell
.\GeneSelfSign.ps1 -Description "MyApp本番証明書" -ScriptFile "C:\Apps\MyApp.exe"
```

## スクリプトの動作

1. **入力検証**: 指定されたファイルパスが有効かチェック
2. **証明書作成**: 以下の仕様で新しい自己署名コード署名証明書を生成：
   - 4096ビットキー長のRSAアルゴリズム
   - コード署名目的
   - 2099年1月1日まで有効
   - 現在のユーザーの証明書ストアに保存
3. **ルートストアへの移動**: 証明書を信頼されたルート証明書ストアに転送
4. **署名の適用**: 生成された証明書で指定されたファイルやディレクトリに署名

## 証明書の詳細

- **サブジェクト**: `CN={Description}, OU=Self-signed RootCA`
- **キーアルゴリズム**: RSA
- **キー長**: 4096ビット
- **証明書タイプ**: コード署名
- **ストア場所**: `Cert:\CurrentUser\My\`（その後`Cert:\CurrentUser\Root`に移動）
- **有効期限**: 2099年1月1日

## セキュリティに関する考慮事項

⚠️ **重要**: このスクリプトは自己署名証明書を作成します。これらは開発やテストに適していますが、本番環境では使用すべきではありません。本番環境での使用には、信頼された証明局（CA）からの証明書の使用を検討してください。

## トラブルシューティング

### 一般的な問題

1. **実行ポリシーエラー**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **権限拒否**
   - PowerShellを管理者として実行
   - 証明書ストアへのアクセス権限を確認

3. **ファイルが見つからない**
   - ファイルパスが正しいことを確認
   - 必要に応じて絶対パスを使用

### 検証

署名が正常に適用されたかどうかを確認するには：
```powershell
Get-AuthenticodeSignature "path\to\your\file"
```
