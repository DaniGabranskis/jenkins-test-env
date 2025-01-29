FROM jenkins/jenkins:lts AS test-env

USER root

# Устанавливаем Docker внутри Jenkins-контейнера
RUN apt-get update && apt-get install -y docker.io

# Добавляем пользователя jenkins в группу с GID 988 (чтобы он имел доступ к docker.sock)
RUN usermod -aG docker jenkins

# Переключаемся обратно на пользователя Jenkins
USER jenkins

WORKDIR /app

COPY . .

EXPOSE 8080
