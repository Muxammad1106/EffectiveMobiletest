#!/bin/bash

set -e

echo "=== Удаление системы мониторинга процесса 'test' ==="

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: Требуются права root. Запустите: sudo ./uninstall.sh"
    exit 1
fi

# Остановка и отключение таймера
echo "Остановка сервисов..."
systemctl stop test-monitor.timer 2>/dev/null || true
systemctl disable test-monitor.timer 2>/dev/null || true

# Удаление systemd юнитов
echo "Удаление systemd юнитов..."
rm -f /etc/systemd/system/test-monitor.service
rm -f /etc/systemd/system/test-monitor.timer

# Перезагрузка systemd
systemctl daemon-reload

# Удаление скрипта
echo "Удаление скрипта..."
rm -f /usr/local/bin/monitor.sh

# Удаление файла состояния
rm -f /tmp/test_monitor_state

echo ""
echo "✓ Удаление завершено успешно!"
echo ""
echo "Примечание: Лог-файл /var/log/monitoring.log сохранен."
echo "Удалить вручную: sudo rm /var/log/monitoring.log"


