# pm07-v09
Учебная практика ПМ.07, вариант 09 «Туристическое агентство».
СУБД PostgreSQL 16, ОС Ubuntu Server 22.04, пользователь vboxuser, папка /home/vboxuser/pm07.

## Файлы
- `input.sql` — данные варианта (tours, clients, bookings, access_probe).
- `setup-rights.sql` — шаблон создания ролей и выдачи прав (пароли — плейсхолдеры).
- `run.sh` — каркас скрипта с операцией варианта 09 и дополнением elapsed_ms.
- `config.example.env` — пример параметров (скопировать в `config.env`).
- `pgpass.example` — пример парольного профиля (скопировать в `auth/pgpass`, подставить пароль, `chmod 600`).
- `rows-before.txt`, `rows-after.txt` — сверка данных до и после восстановления.
- `manual.dump`, `manual.dump.sha256` — ручная резервная копия и её хеш.
- `run-log-excerpt.txt`, `fresh_bookings.log` — доказательства работы скрипта.

## Запуск
1. `cp config.example.env config.env`
2. `mkdir -p auth && cp pgpass.example auth/pgpass` (заменить `OWN_PASSWORD` на свой, `chmod 600 auth/pgpass`)
3. `bash ./run.sh`

## Расписание
cron, ежечасно:
`0 * * * * /bin/bash "$HOME/pm07/run.sh" >> "$HOME/pm07/logs/cron.log" 2>&1`

## Ожидаемый результат
При учебном `CHECK_TIME="2026-11-04 09:30:00"` операция возвращает `count=1`, код завершения `0`.
Пароли в репозитории отсутствуют.
