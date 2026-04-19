<?php
session_start();

if (empty($_SESSION["token"])) {
    header("Location: login.php");
    exit;
}

$apiBase = "http://127.0.0.1:8081";
$error = "";
$success = "";
$items = [];
$categories = [];

function shouldLogout($msg)
{
    return (
        stripos($msg, "Non authentifié") !== false ||
        stripos($msg, "prestataire requis") !== false ||
        stripos($msg, "non validé") !== false ||
        stripos($msg, "Accès refusé") !== false
    );
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST["action"] ?? "";

    if ($action === "add_service") {
        $serviceTypeID = (int)($_POST["service_type_id"] ?? 0);

        if ($serviceTypeID <= 0) {
            $error = "Service invalide.";
        } else {
            $payload = ["service_type_id" => $serviceTypeID];

            $ch = curl_init($apiBase . "/api/provider/services");
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "Content-Type: application/json",
                "X-Token: " . $_SESSION["token"],
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
            $resp = curl_exec($ch);
            curl_close($ch);

            $data = json_decode($resp ?: "", true);

            if (empty($data["success"])) {
                $msg = $data["message"] ?? "";
                if (shouldLogout($msg)) {
                    session_destroy();
                    header("Location: login.php");
                    exit;
                }
                $error = $msg ?: "Erreur ajout service.";
            } else {
                $payload2 = [
                    "custom_title"     => trim($_POST["custom_title"] ?? ""),
                    "negotiated_price" => (float)($_POST["negotiated_price"] ?? 0),
                    "experience_years" => (int)($_POST["experience_years"] ?? 0),
                    "is_active"        => !empty($_POST["is_active"]),
                ];

                $ch = curl_init($apiBase . "/api/provider/services/" . $serviceTypeID);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
                curl_setopt($ch, CURLOPT_HTTPHEADER, [
                    "Content-Type: application/json",
                    "X-Token: " . $_SESSION["token"],
                ]);
                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload2));
                $resp2 = curl_exec($ch);
                curl_close($ch);

                $data2 = json_decode($resp2 ?: "", true);
                if (empty($data2["success"])) {
                    $msg2 = $data2["message"] ?? "";
                    if (shouldLogout($msg2)) {
                        session_destroy();
                        header("Location: login.php");
                        exit;
                    }
                    $error = $msg2 ?: "Service ajouté, mais erreur de configuration.";
                } else {
                    $success = "Service ajouté.";
                }
            }
        }
    }

    if ($action === "update_service") {
        $serviceTypeID = (int)($_POST["service_type_id"] ?? 0);

        if ($serviceTypeID <= 0) {
            $error = "Service invalide.";
        } else {
            $payload = [
                "custom_title"     => trim($_POST["custom_title"] ?? ""),
                "negotiated_price" => (float)($_POST["negotiated_price"] ?? 0),
                "experience_years" => (int)($_POST["experience_years"] ?? 0),
                "is_active"        => !empty($_POST["is_active"]),
            ];

            $ch = curl_init($apiBase . "/api/provider/services/" . $serviceTypeID);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "Content-Type: application/json",
                "X-Token: " . $_SESSION["token"],
            ]);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
            $resp = curl_exec($ch);
            curl_close($ch);

            $data = json_decode($resp ?: "", true);

            if (empty($data["success"])) {
                $msg = $data["message"] ?? "";
                if (shouldLogout($msg)) {
                    session_destroy();
                    header("Location: login.php");
                    exit;
                }
                $error = $msg ?: "Erreur mise à jour service.";
            } else {
                $success = "Service mis à jour.";
            }
        }
    }

    if ($action === "delete_service") {
        $serviceTypeID = (int)($_POST["service_type_id"] ?? 0);

        if ($serviceTypeID <= 0) {
            $error = "Service invalide.";
        } else {
            $ch = curl_init($apiBase . "/api/provider/services/" . $serviceTypeID);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "X-Token: " . $_SESSION["token"],
            ]);
            $resp = curl_exec($ch);
            curl_close($ch);

            $data = json_decode($resp ?: "", true);

            if (empty($data["success"])) {
                $msg = $data["message"] ?? "";
                if (shouldLogout($msg)) {
                    session_destroy();
                    header("Location: login.php");
                    exit;
                }
                $error = $msg ?: "Erreur suppression service.";
            } else {
                $success = "Service supprimé.";
            }
        }
    }

    if ($action === "submit_service") {
        $serviceTypeID = (int)($_POST["service_type_id"] ?? 0);

        $ch = curl_init($apiBase . "/api/provider/services-submit/" . $serviceTypeID);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
        curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
        $resp = curl_exec($ch);
        curl_close($ch);

        $data = json_decode($resp ?: "", true);

        if (empty($data["success"])) {
            $msg = $data["message"] ?? "";
            if (shouldLogout($msg)) {
                session_destroy();
                header("Location: login.php");
                exit;
            }
            $error = $msg ?: "Erreur soumission.";
        } else {
            $success = "Service soumis à validation.";
        }
    }
}

$ch = curl_init($apiBase . "/api/provider/service-types");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);
if (empty($data["success"])) {
    $msg = $data["message"] ?? "";
    if (shouldLogout($msg)) {
        session_destroy();
        header("Location: login.php");
        exit;
    }
    $error = $error ?: ($msg ?: "Erreur chargement liste services.");
} else {
    $categories = $data["categories"] ?? [];
}

$ch = curl_init($apiBase . "/api/provider/services");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);
if (empty($data["success"])) {
    $msg = $data["message"] ?? "";
    if (shouldLogout($msg)) {
        session_destroy();
        header("Location: login.php");
        exit;
    }
    $error = $error ?: ($msg ?: "Erreur chargement services.");
} else {
    $items = $data["items"] ?? [];
}

require __DIR__ . "/../templates/provider/provider_services_view.php";
