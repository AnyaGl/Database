CREATE TABLE Cinema
(id_cinema int NOT NULL IDENTITY,
name_cinema nvarchar(20) NOT NULL,
address_cinema nvarchar(50) NOT NULL,
phone char(12) NULL,
website nvarchar(50) NULL
)
GO

CREATE TABLE Movie
(id_movie int NOT NULL IDENTITY,
title nvarchar(20) NOT NULL,
duration int NULL,
producer nvarchar(20) NULL,
country nvarchar(20) NULL
)
GO

CREATE TABLE Movie_rental
(id_cinema int NOT NULL,
id_movie int NOT NULL,
start_rental date NOT NULL,
finish_rental date NOT NULL
)
GO

ALTER TABLE Cinema
ADD
PRIMARY KEY(id_cinema)
GO

ALTER TABLE Movie
ADD
PRIMARY KEY(id_movie)
GO

ALTER TABLE Movie_rental
ADD
PRIMARY KEY(id_movie, id_cinema)
GO

ALTER TABLE Movie_rental
ADD
FOREIGN KEY(id_movie) REFERENCES Movie(id_movie)
ON DELETE NO ACTION
GO

ALTER TABLE Movie_rental
ADD
FOREIGN KEY(id_cinema) REFERENCES Cinema(id_cinema)
ON DELETE CASCADE
GO


INSERT Cinema
(name_cinema, address_cinema, phone, website)
VALUES
('Super8', 'ул. Кирова', '8362383800', 'https://xn--8-itb3afcm.xn--p1ai/'),
('Октябрь', 'ул. Кремлевская', '30-43-83', 'http://grandkino.ru/')
GO

INSERT Movie
(title, duration, producer, country)
VALUES
('Лед-2', 132, 'Жора Крыжовников', 'Россия'),
('Зов предков', 100, 'Крис Сандерс', 'США'),
('Джентельмены', 113, '	Гай Ричи', 'США')
GO


INSERT Movie_rental
(id_cinema, id_movie, start_rental, finish_rental)
VALUES
(1, 1, DATEFROMPARTS ( 2020, 02, 14 ), DATEFROMPARTS ( 2020, 02, 25 )),
(1, 2, DATEFROMPARTS ( 2020, 02, 25 ), DATEFROMPARTS ( 2020, 03, 05 )),
(1, 3, DATEFROMPARTS ( 2020, 02, 23 ), DATEFROMPARTS ( 2020, 03, 10 )),
(2, 1, DATEFROMPARTS ( 2020, 02, 14 ), DATEFROMPARTS ( 2020, 03, 01 )),
(2, 2, DATEFROMPARTS ( 2020, 02, 25 ), DATEFROMPARTS ( 2020, 03, 05 ))
GO


SELECT * FROM Cinema
SELECT * FROM Movie
SELECT * FROM Movie_rental