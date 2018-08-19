CREATE DATABASE movielens;

CREATE TABLE movielens.movies (
	movieID INT PRIMARY KEY NOT NULL,
	title TEXT,
	releaseDate DATE
);