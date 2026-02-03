enum PetAppointmentType { vet, vacc, deworm, med, groom, other }

extension PetAppointmentTypeExt on PetAppointmentType {
  String get name {
    switch (this) {
      case PetAppointmentType.vet:
        return 'Vet Visit';

      case PetAppointmentType.vacc:
        return 'Vaccination';

      case PetAppointmentType.deworm:
        return 'Deworming';

      case PetAppointmentType.med:
        return 'Medication';

      case PetAppointmentType.groom:
        return 'Grooming';

      case PetAppointmentType.other:
        return 'Other';
    }
  }
}
