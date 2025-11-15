#!/bin/bash

set -e

echo "=== Установка системы мониторинга процесса 'test' ==="

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: Требуются права root. Запустите: sudo ./install.sh"
    exit 1
fi

# Копирование скрипта
echo "Копирование скрипта мониторинга..."
cp bin/monitor.sh /usr/local/bin/monitor.sh
chmod +x /usr/local/bin/monitor.sh

# Создание лог-файла
echo "Создание лог-файла..."
touch /var/log/monitoring.log
chmod 644 /var/log/monitoring.log

# Копирование systemd юнитов
echo "Установка systemd сервисов..."
cp systemd/test-monitor.service /etc/systemd/system/
cp systemd/test-monitor.timer /etc/systemd/system/

# Перезагрузка systemd
echo "Перезагрузка конфигурации systemd..."
systemctl daemon-reload

# Включение и запуск таймера
echo "Включение таймера мониторинга..."
systemctl enable test-monitor.timer
systemctl start test-monitor.timer

echo ""
echo "✓ Установка завершена успешно!"
echo ""
echo "Статус таймера:"
systemctl status test-monitor.timer --no-pager
echo ""
echo "Логи можно посмотреть в: /var/log/monitoring.log"
echo "Управление:"
echo "  - Остановить:  sudo systemctl stop test-monitor.timer"
echo "  - Запустить:   sudo systemctl start test-monitor.timer"
echo "  - Посмотреть:  sudo systemctl status test-monitor.timer"


