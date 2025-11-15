#!/bin/bash

# Конфигурация
PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
STATE_FILE="/tmp/test_monitor_state"

# Функция для записи в лог
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Проверка существования процесса
is_process_running() {
    pgrep -x "$PROCESS_NAME" > /dev/null 2>&1
    return $?
}

# Получение PID процесса
get_process_pid() {
    pgrep -x "$PROCESS_NAME" | head -n1
}

# Отправка запроса на сервер мониторинга
send_monitoring_request() {
    if ! curl -s -f -X POST "$MONITORING_URL" --max-time 10 > /dev/null 2>&1; then
        log_message "Ошибка: Сервер мониторинга недоступен ($MONITORING_URL)"
        return 1
    fi
    return 0
}

# Основная логика
main() {
    # Проверяем, запущен ли процесс
    if is_process_running; then
        current_pid=$(get_process_pid)
        
        # Читаем предыдущий PID
        if [ -f "$STATE_FILE" ]; then
            previous_pid=$(cat "$STATE_FILE")
        else
            previous_pid=""
        fi
        
        # Сохраняем текущий PID
        echo "$current_pid" > "$STATE_FILE"
        
        # Если PID изменился - процесс был перезапущен
        if [ -n "$previous_pid" ] && [ "$previous_pid" != "$current_pid" ]; then
            log_message "Процесс '$PROCESS_NAME' был перезапущен (старый PID: $previous_pid, новый PID: $current_pid)"
        fi
        
        # Отправляем запрос на сервер мониторинга
        send_monitoring_request
    else
        # Процесс не запущен - удаляем файл состояния если он есть
        [ -f "$STATE_FILE" ] && rm -f "$STATE_FILE"
    fi
}

main


