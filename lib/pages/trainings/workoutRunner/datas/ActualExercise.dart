class ActualExercise {
  int numeroExercise;      // Numéro ou index de l'exercice dans la séance
  int numeroSerie;         // Numéro de la série dans l'exercice
  int? reps;               // Nombre de répétitions à réaliser (optionnel)
  int? duration;           // Durée à réaliser (en secondes, optionnel)

  ActualExercise({
    required this.numeroExercise,
    required this.numeroSerie,
    this.reps,
    this.duration,
  });
}

