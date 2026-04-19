<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prestations - Silver Happy</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <header>
        <nav class="navbar navbar-expand-lg navbar-custom">
            <div class="container-fluid">
                <button class="btn text-white fs-3"><i class="bi bi-list"></i></button>
                <form class="d-flex mx-auto" style="width: 50%;">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Rechercher">
                        <button class="btn btn-light" type="submit"><i class="bi bi-search"></i></button>
                    </div>
                </form>
                <div class="d-flex text-white fs-3 gap-3">
                    <i class="bi bi-envelope"></i>
                    <i class="bi bi-person-circle"></i>
                </div>
            </div>
        </nav>
    </header>

    
    <main class="container-fluid px-md-5">
        <?php foreach ($categories as $categoryName => $providers): ?>
            <section class="category-section">
                <h2 class="category-title"><?= htmlspecialchars($categoryName) ?></h2>
                <div class="slider-container">
                    <button class="arrow-btn left-arrow"><i class="bi bi-chevron-left"></i></button>
                    <div class="cards-wrapper">
                        <?php foreach ($providers as $provider): ?>
                            <div class="card provider-card">
                                <div class="card-img-placeholder"></div>
                                <div class="card-body-custom">
                                    <h5><?= htmlspecialchars($provider['Company_Name']) ?></h5>
                                    <a href="profil.php?id=<?= $provider['Id_USER'] ?>" class="btn btn-custom">Voir le profil</a>
                                    <a href="#" class="btn btn-custom">Réserver</a>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                    <button class="arrow-btn right-arrow"><i class="bi bi-chevron-right"></i></button>
                </div>
            </section>
        <?php endforeach; ?>
    </main>

    <script>
        document.querySelectorAll('.category-section').forEach(section => {
            const wrapper = section.querySelector('.cards-wrapper');
            const leftBtn = section.querySelector('.left-arrow');
            const rightBtn = section.querySelector('.right-arrow');

            leftBtn.addEventListener('click', () => {
                wrapper.scrollBy({ left: -300, behavior: 'smooth' });
            });

            rightBtn.addEventListener('click', () => {
                wrapper.scrollBy({ left: 300, behavior: 'smooth' });
            });
        });
    </script>
</body>
</html>