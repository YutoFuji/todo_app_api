# マイグレーション

このプロジェクトではマイグレーションにridgepoleを使用しています。

## 使用方法

以下のコマンドを実行して、スキーマの変更を行います。
```
docker-compose run --rm rails bundle exec ridgepole -c config/database.yml --apply -f db/Schemafile
```

# Swagger Preview

このプロジェクトはSwagger UIとSwagger EditorをDocker Composeを使用して起動します。

## 使用方法

以下のコマンドを実行して、Swagger UIとSwagger Editorをバックグラウンドで起動します。

```
docker-compose -f docker-swagger-compose.yaml up -d
```

アクセス

http://localhost:8002
