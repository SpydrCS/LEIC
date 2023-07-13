.mode columns
.header on
.nullvalue NULL

PRAGMA foreign_keys = ON;


CREATE TRIGGER Email_Cliente
BEFORE INSERT ON Cliente
FOR EACH ROW
WHEN new.email NOT LIKE '%_@__%._%'
BEGIN
    SELECT Raise(rollback,'Email invalido')
END;
END;



CREATE TRIGGER Email1_Cliente
    BEFORE UPDATE OF email ON Cliente
    FOR EACH ROW
    WHEN new.email NOT LIKE '%_@__%._%'
BEGIN
    SELECT Raise(rollback,'Email invalido')
END;
END;



