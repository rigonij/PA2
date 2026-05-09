<?php
require __DIR__ . "/provider_guard.php";
$error = "";
$success = "";


if (!empty($_GET["ok"])) {
    switch ($_GET["ok"]) {
        case "schedule_added":
            $success = "Créneau ajouté.";
            break;
        case "schedule_deleted":
            $success = "Créneau supprimé.";
            break;
        case "absence_added":
            $success = "Absence ajoutée.";
            break;
        case "absence_deleted":
            $success = "Absence supprimée.";
            break;
    }
}
if (!empty($_GET["err"])) {
    $error = (string)$_GET["err"];
}


if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST["action"] ?? "";

    if ($action === "add_schedule") {
        $day = (int)($_POST["day_of_week"] ?? 0);
        $start = trim($_POST["start_time"] ?? "");
        $end = trim($_POST["end_time"] ?? "");

        if ($day < 1 || $day > 7) {
            header("Location: provider_disponibilites.php?err=" . urlencode("Jour invalide (1-7)."));
            exit;
        }
        if ($start === "" || $end === "") {
            header("Location: provider_disponibilites.php?err=" . urlencode("Heures obligatoires."));
            exit;
        }
        if ($end <= $start) {
            header("Location: provider_disponibilites.php?err=" . urlencode("L'heure de fin doit être après l'heure de début."));
            exit;
        }

        $payload = [
            "day_of_week" => $day,
            "start_time"  => $start,
            "end_time"    => $end,
        ];

        $ch = curl_init($apiBase . "/api/provider/schedule");
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
            if (
                stripos($msg, "Non authentifié") !== false ||
                stripos($msg, "prestataire requis") !== false ||
                stripos($msg, "non validé") !== false ||
                stripos($msg, "Accès refusé") !== false
            ) {
                session_destroy();
                header("Location: login.php");
                exit;
            }
            header("Location: provider_disponibilites.php?err=" . urlencode($msg ?: "Erreur ajout créneau."));
            exit;
        }

        header("Location: provider_disponibilites.php?ok=schedule_added");
        exit;
    }

    if ($action === "delete_schedule") {
        $id = (int)($_POST["id"] ?? 0);
        if ($id <= 0) {
            header("Location: provider_disponibilites.php?err=" . urlencode("ID invalide."));
            exit;
        }

        $ch = curl_init($apiBase . "/api/provider/schedule/" . $id);
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
            if (
                stripos($msg, "Non authentifié") !== false ||
                stripos($msg, "prestataire requis") !== false ||
                stripos($msg, "non validé") !== false ||
                stripos($msg, "Accès refusé") !== false
            ) {
                session_destroy();
                header("Location: login.php");
                exit;
            }
            header("Location: provider_disponibilites.php?err=" . urlencode($msg ?: "Erreur suppression créneau."));
            exit;
        }

        header("Location: provider_disponibilites.php?ok=schedule_deleted");
        exit;
    }

    if ($action === "add_absence") {
        $start = trim($_POST["start_datetime"] ?? "");
        $end = trim($_POST["end_datetime"] ?? "");

        if ($start === "" || $end === "") {
            header("Location: provider_disponibilites.php?err=" . urlencode("Dates obligatoires."));
            exit;
        }
        if ($end <= $start) {
            header("Location: provider_disponibilites.php?err=" . urlencode("La fin doit être après le début."));
            exit;
        }

        $payload = [
            "start_datetime" => $start,
            "end_datetime"   => $end,
        ];

        $ch = curl_init($apiBase . "/api/provider/absence");
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
            if (
                stripos($msg, "Non authentifié") !== false ||
                stripos($msg, "prestataire requis") !== false ||
                stripos($msg, "non validé") !== false ||
                stripos($msg, "Accès refusé") !== false
            ) {
                session_destroy();
                header("Location: login.php");
                exit;
            }
            header("Location: provider_disponibilites.php?err=" . urlencode($msg ?: "Erreur ajout absence."));
            exit;
        }

        header("Location: provider_disponibilites.php?ok=absence_added");
        exit;
    }

    if ($action === "delete_absence") {
        $id = (int)($_POST["id"] ?? 0);
        if ($id <= 0) {
            header("Location: provider_disponibilites.php?err=" . urlencode("ID invalide."));
            exit;
        }

        $ch = curl_init($apiBase . "/api/provider/absence/" . $id);
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
            if (
                stripos($msg, "Non authentifié") !== false ||
                stripos($msg, "prestataire requis") !== false ||
                stripos($msg, "non validé") !== false ||
                stripos($msg, "Accès refusé") !== false
            ) {
                session_destroy();
                header("Location: login.php");
                exit;
            }
            header("Location: provider_disponibilites.php?err=" . urlencode($msg ?: "Erreur suppression absence."));
            exit;
        }

        header("Location: provider_disponibilites.php?ok=absence_deleted");
        exit;
    }

    header("Location: provider_disponibilites.php");
    exit;
}


$schedules = [];
$absences = [];

$ch = curl_init($apiBase . "/api/provider/schedule");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);

if (empty($data["success"])) {
    $msg = $data["message"] ?? "";
    if (
        stripos($msg, "Non authentifié") !== false ||
        stripos($msg, "prestataire requis") !== false ||
        stripos($msg, "non validé") !== false ||
        stripos($msg, "Accès refusé") !== false
    ) {
        session_destroy();
        header("Location: login.php");
        exit;
    }
    $error = $error ?: ($msg ?: "Erreur chargement créneaux.");
} else {
    $schedules = $data["items"] ?? [];
}

$ch = curl_init($apiBase . "/api/provider/absence");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
$resp = curl_exec($ch);
curl_close($ch);

$data = json_decode($resp ?: "", true);

if (empty($data["success"])) {
    $msg = $data["message"] ?? "";
    if (
        stripos($msg, "Non authentifié") !== false ||
        stripos($msg, "prestataire requis") !== false ||
        stripos($msg, "non validé") !== false ||
        stripos($msg, "Accès refusé") !== false
    ) {
        session_destroy();
        header("Location: login.php");
        exit;
    }
    $error = $error ?: ($msg ?: "Erreur chargement absences.");
} else {
    $absences = $data["items"] ?? [];
}

require __DIR__ . "/../templates/provider/provider_disponibilites_view.php";
