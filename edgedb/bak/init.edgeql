# DESCRIBE SYSTEM CONFIG
CONFIGURE INSTANCE SET session_idle_transaction_timeout := <std::duration>'PT10S';

# DESCRIBE ROLES
ALTER ROLE edgedb { SET password_hash := 'SCRAM-SHA-256$4096:qro7zFHZUfO3EXewFzsRww==$nI3ymAo08wpnfGULU0Lk8s0seWJQd8oms6CGtwIjVHs=:/YXdb7GTP5sZwcmUS/rZA2IfhSf7+ZUef3iIaxOoX6c=';};
