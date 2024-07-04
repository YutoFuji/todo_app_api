# サーバー起動

Docker Composeを使用してサーバーを立ち上げます。

## 使用方法

以下のコマンドを実行します。
```
docker-compose up -d
```

下記URLにアクセスします。

http://localhost:8888

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

下記URLにアクセスします。

http://localhost:8002

# テストツール

このプロジェクトではテストにRSpecを使用しています。

## 使用方法

以下のコマンドを実行してRSpecを流します。

```
docker-compose run --rm rails bundle exec rspec
```
