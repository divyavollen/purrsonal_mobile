enum PetSpecies { cat, dog, bird, bunny, other }

extension PetSpeciesExt on PetSpecies {
  String get name {
    switch (this) {
      case PetSpecies.cat:
        return 'Cat';

      case PetSpecies.dog:
        return 'Dog';

      case PetSpecies.bird:
        return 'Bird';

      case PetSpecies.bunny:
        return 'Bunny';

      case PetSpecies.other:
        return 'Other';
    }
  }
}
