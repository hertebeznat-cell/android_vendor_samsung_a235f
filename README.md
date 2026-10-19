# Galaxy A23 4G (SM-A235F) — стоковые vendor/odm SEZB1

Ветка `cnb-clean`. Содержит **неизменённые** образы `vendor.img` и `odm.img`
из `A235FXXSEEZB1` (AP `..._MULTI_CERT_meta_OS14`), раздел `super`
группы `qti_dynamic_partitions`.

- `images/` — образы, сжатые xz и разбитые на части < 100 МиБ (лимит GitHub),
  и `SHA256SUMS` для частей и итоговых образов.
- `tools/assemble_images.py` — собирает образы из частей и сверяет хеши
  (вызывается сборкой автоматически, идемпотентен).
- `tools/pack_images.py` — как части были получены.
- `reference/` — текстовые копии стоковой SELinux-политики и VINTF для
  проверок при сборке (`device/samsung/a23/tools/check_stock_sepolicy.sh`).

| Образ | Размер | SHA256 |
|---|---|---|
| vendor.img | 922710016 | `dfef9d6458bc9352c830b96e8b7ec9a9247c28c82ca9f175b7b8a4a018d8a30d` |
| odm.img | 21389312 | `cf8f0b292fe4832a64eb406dd2b32a02c29115f848e5b435a39b45594ea60003` |
