import ballerinax/postgresql;

public final postgresql:Client dbClient =
                               check new (host="localhost", username = "postgres", password="Massil1234", port=5432, database="Factory_db");
