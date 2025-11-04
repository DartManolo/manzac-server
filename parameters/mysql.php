<?php
    Class Mysql {
        var $conn;

        function __construct() {
            $this->conection();
        }

        public function conection() {
            $mysql_params = explode("~", getenv('MYSQLCONNML'));
            $this->conn = mysqli_init();
            $this->conn->options(MYSQLI_OPT_CONNECT_TIMEOUT, 300);
            $this->conn->options(MYSQLI_SET_CHARSET_NAME, "utf8");
            $this->conn->real_connect(
                $mysql_params[0],
                'root',
                'root',
                $mysql_params[3]
            );
        }

        public function executeReader($query, $single = false) {
            $resultado = array();
            if($execute_query = $this->conn->query($query)) {
                while($reader = $execute_query->fetch_object()) {
                    $resultado[] = $reader;
                }
                while ($this->conn->more_results() && $this->conn->next_result());
                if(count($resultado) > 0 && $single) {
                    $resultado = $resultado[0];
                }
            }
            return $resultado;
        }

        public function executeNonQuery($query, $params = []) {
            $stmt = $this->conn->prepare($query);
            if (!$stmt) {
                return $stmt->error;
            }
            if (!empty($params)) {
                $types = '';
                $values = [];
                foreach ($params as $param) {
                    if (is_int($param)) {
                        $types .= 'i';
                    } elseif (is_float($param)) {
                        $types .= 'd';
                    } elseif (is_string($param)) {
                        $types .= 's';
                    } else {
                        $types .= 'b';
                    }
                    $values[] = $param;
                }
                $stmt->bind_param($types, ...$values);
            }
            if (!$stmt->execute()) {
                return $stmt->error;
            }
            do {
                if ($result = $stmt->get_result()) {
                    $result->free();
                }
            } while ($stmt->more_results() && $stmt->next_result());
            return true;
        }
    }
?>