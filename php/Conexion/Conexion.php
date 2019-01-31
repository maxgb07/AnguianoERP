<?php

    class MySQL {
        // The database connection
        protected static $connection;

        /**
         * Connect to the database
         * 
         * @return bool false on failure / mysqli MySQLi object instance on success
         */
        public function connect() {    
            // Try and connect to the database
            if(!isset(self::$connection)) {
                // Load configuration as an array. Use the actual location of your configuration file
                //$config = parse_ini_file('./config.ini'); 
                self::$connection = new mysqli("localhost:8889","root","root",'clutchyf_ERP');
            }

            // If connection was not successful, handle the error
            if(self::$connection === false) {
                if ($mysqli->connect_errno) {
                    echo "Falló la conexión a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
                    }
                return false;
            }
            return self::$connection;
        }

        /**
         * Query the database
         *
         * @param $query The query string
         * @return mixed The result of the mysqli::query() function
         */
        public function query($query) {
            // Connect to the database
            $connection = $this -> connect();

            // Query the database
            $result = $connection -> query($query);

            return $result;
        }

        /**
         * Fetch rows from the database (SELECT query)
         *
         * @param $query The query string
         * @return bool False on failure / array Database rows on success
         */
        public function select($query) {
            $rows = array();
            $result = $this -> query($query);
            if($result === false) {
                echo "CALL failed: (" . $mysqli->errno . ") " . $mysqli->error;
                return false;
            }
            while ($row = $result -> fetch_assoc()) {
                $rows[] = $row;
            }
            return $rows;
        }

        /**
         * Fetch the last error from the database
         * 
         * @return string Database error message
         */
        public function error() {
            $connection = $this -> connect();
            return $connection -> error;
        }

        /**
         * Quote and escape value for use in a database query
         *
         * @param string $value The value to be quoted and escaped
         * @return string The quoted and escaped string
         */
        public function quote($value) {
            $connection = $this -> connect();
            return "'" . $connection -> real_escape_string($value) . "'";
        }
    }

// si existe algun error hay que acivar las siguientes lineas en el php.ini del servidor  extension:dir= "C:\php\ext"
// y extension = php_mysql.dll
/*class MySQL {

    private $conexion;
    private $total_consultas;

    public function MySQL() {
        if (!isset($this->conexion)) {
             $this->conexion = (mysql_connect("216.245.217.234", "taddibri_apptaxi", "apptaxi2016"))
             //$this->conexion = (mysql_connect("localhost", "root", ""))
                    or die(mysql_error());
  
            mysql_select_db("taddibri_apptaxi", $this->conexion) or die(mysql_error());
            //mysql_select_db("app_taxi", $this->conexion) or die(mysql_error());

        }
    }

    public function consulta($consulta) {
        $this->total_consultas++;
        $resultado = mysql_query($consulta, $this->conexion);
        if (!$resultado) {
            echo 'MySQL Error: ' . mysql_error();
            exit;
        }
        return $resultado;
    }

    public function fetch_array($consulta) {
        return mysql_fetch_array($consulta);
    }

    public function num_rows($consulta) {
        return mysql_num_rows($consulta);
    }

    public function getTotalConsultas() {
        return $this->total_consultas;
    }

}
*/
?>