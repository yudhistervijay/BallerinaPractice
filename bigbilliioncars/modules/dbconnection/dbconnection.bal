import ballerinax/postgresql;

public final postgresql:Client dbClient =
                               check new (host="localhost", username = "postgres", password="12345", port=5432, database="postgres");
