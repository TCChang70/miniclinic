FROM maven:3.9-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 第二階段：只帶 JAR 執行，image 較小
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build \
  /app/target/*.jar app.jar

# 容器啟動時執行 JAR，並明確指定使用 prod Profile
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-jar", "app.jar"]

# 宣告服務使用的 port（Render 預設讀取此值）
EXPOSE 8080
