<div class="modal fade" id="tutorialModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="badge badge-sh mb-2" id="tStep">Tutoriel • Étape 1/3</div>
                <h2 class="h5 mb-2" id="tTitle">Bienvenue</h2>
                <p class="text-secondary mb-3" id="tText">...</p>

                <div class="d-flex justify-content-between gap-2">
                    <button class="btn btn-outline-secondary" id="tPrev" onclick="tutorialPrev()" disabled>Précédent</button>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-secondary" onclick="tutorialSkip()">Passer</button>
                        <button class="btn btn-sh-gold" id="tNext" onclick="tutorialNext()">Suivant</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>