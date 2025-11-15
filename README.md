# Система мониторинга процесса

Скрипт для автоматического мониторинга процесса `test` в Linux-системах.

## Возможности

- Автоматический запуск при старте системы
- Проверка процесса каждую минуту
- Отправка уведомлений на сервер мониторинга при работающем процессе
- Логирование перезапусков процесса
- Логирование недоступности сервера мониторинга

## Требования

- Linux с systemd
- curl
- Права root для установки

## Установка

```bash
chmod +x install.sh
sudo ./install.sh
```

После установки мониторинг запустится автоматически и будет работать в фоне.

## Удаление

```bash
chmod +x uninstall.sh
sudo ./uninstall.sh
```

## Структура проекта

```
.
├── bin/
│   └── monitor.sh                 # Основной скрипт мониторинга
├── systemd/
│   ├── test-monitor.service       # Systemd сервис
│   └── test-monitor.timer         # Таймер для запуска каждую минуту
├── install.sh                     # Скрипт установки
├── uninstall.sh                   # Скрипт удаления
└── README.md                      # Документация
```

## Как это работает

1. **Systemd timer** запускает скрипт каждую минуту
2. **Скрипт проверяет** наличие процесса `test` в системе
3. **Если процесс запущен**:
   - Отправляется POST-запрос на `https://test.com/monitoring/test/api`
   - Проверяется, не был ли процесс перезапущен (по изменению PID)
   - При перезапуске информация записывается в `/var/log/monitoring.log`
4. **Если сервер недоступен** - записывается ошибка в лог
5. **Если процесс не запущен** - скрипт завершается без действий

## Управление

Проверить статус:
```bash
sudo systemctl status test-monitor.timer
```

Остановить мониторинг:
```bash
sudo systemctl stop test-monitor.timer
```

Запустить мониторинг:
```bash
sudo systemctl start test-monitor.timer
```

Отключить автозапуск:
```bash
sudo systemctl disable test-monitor.timer
```

Включить автозапуск:
```bash
sudo systemctl enable test-monitor.timer
```

## Логи

Логи работы хранятся в `/var/log/monitoring.log`

Просмотр логов:
```bash
sudo tail -f /var/log/monitoring.log
```

Логи systemd:
```bash
sudo journalctl -u test-monitor.service -f
```

## Конфигурация

Параметры можно изменить в файле `bin/monitor.sh`:

- `PROCESS_NAME` - имя отслеживаемого процесса
- `MONITORING_URL` - URL сервера мониторинга
- `LOG_FILE` - путь к файлу логов

После изменения необходимо переустановить:
```bash
sudo ./uninstall.sh
sudo ./install.sh
```


