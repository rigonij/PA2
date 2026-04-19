let tutorialIndex = 0;

const tutorialSteps = [
  {
    title: "Bienvenue sur SilverHappy",
    text: "Ce site est une maquette front de l’espace Senior. Les actions sont simulées."
  },
  {
    title: "Navigation",
    text: "Utilise le menu à gauche pour accéder aux catalogues, devis, planning, factures, etc."
  },
  {
    title: "Paiement (mock)",
    text: "La page Paiement simule Stripe. L’intégration réelle viendra quand le back sera prêt."
  }
];

function renderTutorialStep(){
  const total = tutorialSteps.length;
  const s = tutorialSteps[tutorialIndex];

  document.getElementById("tStep").textContent = `Tutoriel • Étape ${tutorialIndex + 1}/${total}`;
  document.getElementById("tTitle").textContent = s.title;
  document.getElementById("tText").textContent = s.text;

  const prevBtn = document.getElementById("tPrev");
  const nextBtn = document.getElementById("tNext");

  prevBtn.disabled = tutorialIndex === 0;

  if (tutorialIndex === total - 1){
    nextBtn.textContent = "Terminer";
    nextBtn.classList.remove("btn-sh-gold");
    nextBtn.classList.add("btn-sh-primary");
  } else {
    nextBtn.textContent = "Suivant";
    nextBtn.classList.add("btn-sh-gold");
    nextBtn.classList.remove("btn-sh-primary");
  }
}

function showTutorialIfNeeded(){
  const done = localStorage.getItem("sh_tutorial_done") === "1";
  if (done) return;

  const el = document.getElementById("tutorialModal");
  if (!el) return;

  tutorialIndex = 0;
  renderTutorialStep();

  const modal = new bootstrap.Modal(el, { backdrop: "static", keyboard: false });
  modal.show();
}

function tutorialNext(){
  if (tutorialIndex < tutorialSteps.length - 1){
    tutorialIndex++;
    renderTutorialStep();
    return;
  }
  finishTutorial();
}

function tutorialPrev(){
  tutorialIndex = Math.max(0, tutorialIndex - 1);
  renderTutorialStep();
}

function tutorialSkip(){
  finishTutorial();
}

function finishTutorial(){
  localStorage.setItem("sh_tutorial_done", "1");
  const el = document.getElementById("tutorialModal");
  const modal = bootstrap.Modal.getInstance(el);
  if (modal) modal.hide();
}