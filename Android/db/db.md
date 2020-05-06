# DB

Android 数据库使用相关记录



### Upgrade

```
ALTER TABLE books ADD COLUMN book_rating INTEGER;
ALTER TABLE books RENAME TO book_information;

ALTER TABLE book_information ADD COLUMN calculated_pages_times_rating INTEGER;
UPDATE book_information SET calculated_pages_times_rating = (book_pages * book_rating) ;
```

