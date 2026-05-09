<?php
if (!isset($pageTitle)) $pageTitle = "SilverHappy";

if (!function_exists("fmt_dt")) {
    function fmt_dt($iso, $withTime = true)
    {
        if (empty($iso)) return "";
        try {
            $tz = new DateTimeZone("Europe/Paris");
            $d = new DateTime($iso, $tz);
            $d->setTimezone($tz);
            return $withTime ? $d->format("d/m/Y H:i") : $d->format("d/m/Y");
        } catch (Exception $e) {
            return htmlspecialchars($iso);
        }
    }
}
?>
<!doctype html>
<html lang="fr">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title><?= htmlspecialchars($pageTitle) ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="../public/assets/css/theme.css">
    <link rel="stylesheet" href="../public/assets/css/style.css">
    <link rel="stylesheet" href="../public/assets/css/sh-senior.css">
</head>
<?php include __DIR__ . "/sanction_popup.php"; ?>

<body class="<?= !empty($isSeniorUi) ? "senior-ui" : "" ?>">