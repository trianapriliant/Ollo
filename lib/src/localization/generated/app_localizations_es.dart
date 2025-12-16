// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get wallet => 'Billetera';

  @override
  String get profile => 'Perfil';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get expense => 'Gasto';

  @override
  String get income => 'Ingreso';

  @override
  String get transfer => 'Transferencia';

  @override
  String get amount => 'Monto';

  @override
  String get to => 'A';

  @override
  String get addNoteHint => 'Añadir nota...';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Listo';

  @override
  String get errorInvalidAmount => 'Ingrese un monto válido';

  @override
  String get errorSelectWallet => 'Seleccione una billetera';

  @override
  String get errorSelectDestinationWallet =>
      'Seleccione una billetera de destino';

  @override
  String get errorSameWallets =>
      'Las billeteras de origen y destino deben ser diferentes';

  @override
  String get errorSelectCategory => 'Seleccione una categoría';

  @override
  String get transactionDetail => 'Detalle de Transacción';

  @override
  String get title => 'Título';

  @override
  String get category => 'Categoría';

  @override
  String get dateTime => 'Fecha y Hora';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String get note => 'Nota';

  @override
  String get deleteTransaction => 'Eliminar Transacción';

  @override
  String get deleteTransactionConfirm =>
      '¿Seguro que desea eliminar esta transacción? El saldo se restaurará.';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get markCompleted => 'Marcar como Completado';

  @override
  String get markCompletedConfirm =>
      '¿Marcar este reembolso como pagado/completado?';

  @override
  String get confirm => 'Confirmar';

  @override
  String get system => 'Sistema';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get noTransactions => 'Sin transacciones aún';

  @override
  String get startRecording =>
      '¡Comience a registrar sus gastos e ingresos! 🚀';

  @override
  String get menu => 'Menú';

  @override
  String get budget => 'Presupuesto';

  @override
  String get recurring => 'Recurrente';

  @override
  String get savings => 'Ahorros';

  @override
  String get total => 'Total';

  @override
  String get bills => 'Facturas';

  @override
  String get debts => 'Deudas';

  @override
  String get wishlist => 'Lista de Deseos';

  @override
  String get cards => 'Tarjetas';

  @override
  String get notes => 'Notas';

  @override
  String get reimburse => 'Reembolso';

  @override
  String get unknown => 'Desconocido';

  @override
  String welcome(String name) {
    return '¡Hola, $name!';
  }

  @override
  String get welcomeSimple => '¡Hola!';

  @override
  String get settings => 'Ajustes';

  @override
  String get developerOptions => 'Opciones de Desarrollador';

  @override
  String get futureFeatures => 'Futuras Funciones';

  @override
  String get backupRecovery => 'Respaldo y Recuperación';

  @override
  String get aiAutomation => 'Automatización IA';

  @override
  String get feedbackRoadmap => 'Comentarios y Hoja de Ruta';

  @override
  String get dataExport => 'Exportar Datos';

  @override
  String get dataManagement => 'Gestión de Datos';

  @override
  String get categories => 'Categorías';

  @override
  String get wallets => 'Billeteras';

  @override
  String get general => 'General';

  @override
  String get helpSupport => 'Ayuda y Soporte';

  @override
  String get sendFeedback => 'Enviar Comentarios';

  @override
  String get aboutOllo => 'Sobre Ollo';

  @override
  String get account => 'Cuenta';

  @override
  String get deleteData => 'Eliminar Datos';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get comingSoonDesc =>
      'La IA categorizará sus transacciones y dará consejos financieros.';

  @override
  String get cantWait => '¡No puedo esperar!';

  @override
  String get deleteAllData => '¿Eliminar todos los datos?';

  @override
  String deleteAllDataConfirm(String confirmationText) {
    return 'Esta acción eliminará PERMANENTEMENTE todas sus transacciones, billeteras y notas. No se puede deshacer.\n\nPara confirmar, escriba \"$confirmationText\" abajo:';
  }

  @override
  String get deleteDataConfirmationText => 'Borrar Datos';

  @override
  String get dataDeletedSuccess =>
      'Datos eliminados con éxito. Reinicie la aplicación.';

  @override
  String dataDeleteFailed(String error) {
    return 'Error al eliminar datos: $error';
  }

  @override
  String get currency => 'Moneda';

  @override
  String get language => 'Idioma';

  @override
  String get selectCurrency => 'Seleccionar Moneda';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get selectCategory => 'Seleccionar Categoría';

  @override
  String get myWallets => 'Mis Billeteras';

  @override
  String get emptyWalletsTitle => 'Sin billeteras';

  @override
  String get emptyWalletsMessage =>
      '¡Añada una billetera o cuenta bancaria! 💳';

  @override
  String get addWallet => 'Añadir Billetera';

  @override
  String get editWallet => 'Editar Billetera';

  @override
  String get newWallet => 'Nueva Billetera';

  @override
  String get walletName => 'Nombre de Billetera';

  @override
  String get initialBalance => 'Saldo Inicial';

  @override
  String get walletDetails => 'Detalles de Billetera';

  @override
  String get appearance => 'Apariencia';

  @override
  String get icon => 'Ícono';

  @override
  String get color => 'Color';

  @override
  String get saveWallet => 'Guardar Billetera';

  @override
  String get walletTypeCash => 'Efectivo';

  @override
  String get walletTypeBank => 'Cuenta Bancaria';

  @override
  String get walletTypeEWallet => 'Billetera Digital';

  @override
  String get walletTypeCreditCard => 'Tarjeta de Crédito';

  @override
  String get walletTypeExchange => 'Inversiones';

  @override
  String get walletTypeOther => 'Otros';

  @override
  String get debitCard => 'Tarjeta de Débito';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get noCategoriesFound => 'No se encontraron categorías';

  @override
  String get editCategory => 'Editar Categoría';

  @override
  String get newCategory => 'Nueva Categoría';

  @override
  String get categoryName => 'Nombre de Categoría';

  @override
  String get enterCategoryName => 'Ingrese un nombre';

  @override
  String get deleteCategory => '¿Eliminar Categoría?';

  @override
  String get deleteCategoryConfirm => 'Esta acción no se puede deshacer.';

  @override
  String get save => 'Guardar';

  @override
  String get systemCategoryTitle => 'Categoría del Sistema';

  @override
  String get systemCategoryMessage =>
      'Esta categoría es gestionada por el sistema y no se puede editar.';

  @override
  String get sysCatTransfer => 'Transferencia';

  @override
  String get sysCatTransferDesc => 'Transferencias entre billeteras';

  @override
  String get sysCatRecurring => 'Recurrente';

  @override
  String get sysCatRecurringDesc => 'Transacciones automáticas recurrentes';

  @override
  String get sysCatWishlist => 'Lista de Deseos';

  @override
  String get sysCatWishlistDesc =>
      'Transacciones automáticas de Lista de Deseos';

  @override
  String get sysCatBills => 'Facturas';

  @override
  String get sysCatBillsDesc => 'Pagos automáticos de facturas';

  @override
  String get dueDateLabel => 'Vencimiento';

  @override
  String get statusLabel => 'Estado';

  @override
  String get noPaymentsYet => 'Sin pagos aún';

  @override
  String get sysCatDebts => 'Deudas';

  @override
  String get sysCatDebtsDesc => 'Registros de Deudas/Préstamos';

  @override
  String get sysCatSavings => 'Ahorros';

  @override
  String get sysCatSavingsDesc => 'Depósitos y retiros de ahorros';

  @override
  String get sysCatSmartNotes => 'Notas Inteligentes';

  @override
  String get sysCatSmartNotesDesc => 'Transacciones de Paquetes Inteligentes';

  @override
  String get sysCatReimburse => 'Reembolso';

  @override
  String get sysCatReimburseDesc => 'Sistema de seguimiento de reembolsos';

  @override
  String get budgetsTitle => 'Presupuestos';

  @override
  String get noBudgetsYet => 'Sin presupuestos aún';

  @override
  String get createBudget => 'Crear Presupuesto';

  @override
  String get yourBudgets => 'Tus Presupuestos';

  @override
  String get newBudget => 'Nuevo Presupuesto';

  @override
  String get editBudget => 'Editar Presupuesto';

  @override
  String get limitAmount => 'Monto Límite';

  @override
  String get period => 'Período';

  @override
  String get weekly => 'Semanalmente';

  @override
  String get monthly => 'Mensualmente';

  @override
  String get yearly => 'Anualmente';

  @override
  String get daily => 'Diariamente';

  @override
  String get deleteBudget => 'Eliminar Presupuesto';

  @override
  String get deleteBudgetConfirm =>
      '¿Seguro que desea eliminar este presupuesto?';

  @override
  String get enterAmount => 'Ingrese monto';

  @override
  String get recurringTitle => 'Recurrente';

  @override
  String get activeSubscriptions => 'Suscripciones Activas';

  @override
  String get noActiveSubscriptions => 'Sin suscripciones activas';

  @override
  String get newRecurring => 'Nuevo Recurrente';

  @override
  String get editRecurring => 'Editar Recurrente';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get startDate => 'Fecha de Inicio';

  @override
  String get payWithWallet => 'Pagar con Billetera';

  @override
  String get updateRecurring => 'Actualizar';

  @override
  String get saveRecurring => 'Guardar';

  @override
  String get deleteRecurring => '¿Eliminar Recurrente?';

  @override
  String get deleteRecurringConfirm =>
      'Esto detendrá los pagos futuros. Las transacciones pasadas permanecerán.';

  @override
  String get pleaseSelectWallet => 'Seleccione una billetera';

  @override
  String get debtsTitle => 'Deudas';

  @override
  String get iOwe => 'Debo';

  @override
  String get owedToMe => 'Me Deben';

  @override
  String get netBalance => 'Saldo Neto';

  @override
  String get debtFree => '¡Estás libre de deudas!';

  @override
  String get noOneOwesYou => 'Nadie te debe dinero.';

  @override
  String get paidStatus => 'Pagado';

  @override
  String get overdue => 'Vencido';

  @override
  String dueOnDate(String date) {
    return 'Vence el $date';
  }

  @override
  String amountLeft(String amount) {
    return 'Quedan $amount';
  }

  @override
  String get deleteDebt => '¿Eliminar Deuda?';

  @override
  String get deleteDebtConfirm => 'Esto eliminará el registro de la deuda.';

  @override
  String get sortByDate => 'Por Fecha';

  @override
  String get sortByAmount => 'Por Monto';

  @override
  String get editDebt => 'Editar Deuda';

  @override
  String get addDebt => 'Añadir Deuda';

  @override
  String get iBorrowed => 'Pedí Prestado';

  @override
  String get iLent => 'Presté';

  @override
  String get personName => 'Nombre de la Persona';

  @override
  String get whoHint => '¿Quién?';

  @override
  String get required => 'Requerido';

  @override
  String get updateDebt => 'Actualizar Deuda';

  @override
  String get saveDebt => 'Guardar Deuda';

  @override
  String get debtSaved => 'Deuda guardada';

  @override
  String get debtUpdated => 'Deuda actualizada';

  @override
  String get debtDeleted => 'Deuda eliminada';

  @override
  String get debtDetails => 'Detalles de Deuda';

  @override
  String get paymentHistory => 'Historial de Pagos';

  @override
  String youOweName(String name) {
    return 'Debes a $name';
  }

  @override
  String nameOwesYou(String name) {
    return '$name te debe';
  }

  @override
  String totalAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String paidAmount(String amount) {
    return 'Pagado: $amount';
  }

  @override
  String get activeStatus => 'Activo';

  @override
  String get addPayment => 'Añadir Pago';

  @override
  String get noneRecordOnly => 'Ninguno (Solo registrar)';

  @override
  String get confirmPayment => 'Confirmar Pago';

  @override
  String get paymentRecorded => '¡Pago registrado!';

  @override
  String get deleteDebtWarning =>
      'Esto eliminará el registro. El saldo de la billetera NO se revertirá automáticamente.';

  @override
  String get billsTitle => 'Facturas';

  @override
  String get unpaid => 'Sin Pagar';

  @override
  String get paidTab => 'Pagado';

  @override
  String get allCaughtUp => '¡Todo al día!';

  @override
  String get noUnpaidBills => 'No hay facturas pendientes.';

  @override
  String get noHistoryYet => 'Sin historial';

  @override
  String paidOnDate(String date) {
    return 'Pagado el $date';
  }

  @override
  String get dueToday => 'Vence Hoy';

  @override
  String dueInDays(int days) {
    return 'Vence en $days días';
  }

  @override
  String get pay => 'Pagar';

  @override
  String get payBill => 'Pagar Factura';

  @override
  String payBillTitle(String title) {
    return '¿Pagar \"$title\"?';
  }

  @override
  String get payFrom => 'Pagar desde:';

  @override
  String get noWalletsFound => 'No se encontraron billeteras';

  @override
  String get billPaidSuccess => '¡Factura pagada!';

  @override
  String get editBill => 'Editar Factura';

  @override
  String get addBill => 'Añadir Factura';

  @override
  String get billDetails => 'Detalles de Factura';

  @override
  String get billName => 'Nombre de Factura';

  @override
  String get billType => 'Tipo';

  @override
  String get repeatBill => '¿Repetir factura?';

  @override
  String get autoCreateBill => 'Crear facturas automáticamente';

  @override
  String get updateBill => 'Actualizar';

  @override
  String get saveBill => 'Guardar';

  @override
  String get billSaved => 'Guardado';

  @override
  String get billUpdated => 'Actualizado';

  @override
  String get billDeleted => 'Eliminado';

  @override
  String get payBillDescription =>
      'Esto creará una transacción del sistema y descontará de su billetera.';

  @override
  String get deleteBill => '¿Eliminar Factura?';

  @override
  String get deleteBillConfirm => 'No se puede deshacer.';

  @override
  String get errorInvalidBill => 'Ingrese título y monto válidos';

  @override
  String get wishlistTitle => 'Lista de Deseos';

  @override
  String get activeTab => 'Activo';

  @override
  String get achievedTab => 'Logrado';

  @override
  String get emptyActiveWishlistMessage =>
      'Empiece a añadir cosas que quiere comprar';

  @override
  String get emptyAchievedWishlistMessage =>
      'Aún no hay sueños cumplidos. ¡Siga así!';

  @override
  String get noAchievementsYet => 'Sin logros aún';

  @override
  String get wishlistEmpty => 'Su lista está vacía';

  @override
  String get deleteItemTitle => '¿Eliminar ítem?';

  @override
  String deleteItemConfirm(String title) {
    return '¿Desea eliminar \"$title\"?';
  }

  @override
  String get buy => 'Comprar';

  @override
  String get buyItemTitle => 'Comprar Ítem';

  @override
  String purchaseItemTitle(String title) {
    return '¿Comprar \"$title\"?';
  }

  @override
  String get selectWalletLabel => 'Seleccionar Billetera:';

  @override
  String get noWalletsFoundMessage => 'Cree una billetera primero.';

  @override
  String get amountLabel => 'Monto:';

  @override
  String get confirmPurchase => 'Confirmar Compra';

  @override
  String get purchaseSuccessMessage => '¡Compra exitosa! 🎉';

  @override
  String errorLaunchingUrl(String error) {
    return 'Error al abrir URL: $error';
  }

  @override
  String get editWishlist => 'Editar Lista';

  @override
  String get addWishlist => 'Añadir a Lista';

  @override
  String get addPhoto => 'Añadir Foto';

  @override
  String get itemName => 'Nombre del Ítem';

  @override
  String get itemNameHint => 'ej. Laptop Nueva';

  @override
  String get priceLabel => 'Precio';

  @override
  String get targetDateLabel => 'Fecha Objetivo';

  @override
  String get selectDate => 'Seleccionar Fecha';

  @override
  String get productLinkLabel => 'Enlace del Producto (Opcional)';

  @override
  String get productLinkHint => 'ej. https://amazon.es/...';

  @override
  String get updateWishlist => 'Actualizar';

  @override
  String get saveWishlist => 'Guardar';

  @override
  String get errorInvalidWishlist => 'Ingrese título y precio válidos';

  @override
  String get wishlistUpdated => 'Actualizado';

  @override
  String get wishlistSaved => 'Ítem añadido a la lista!';

  @override
  String get deleteWishlistTitle => '¿Eliminar Lista?';

  @override
  String get deleteWishlistConfirm => 'No se puede deshacer.';

  @override
  String get wishlistDeleted => 'Eliminado';

  @override
  String errorPickingImage(String error) {
    return 'Error al elegir imagen: $error';
  }

  @override
  String get smartNotesTitle => 'Mis Paquetes';

  @override
  String get emptySmartNotesMessage => '¡Cree su primer paquete!';

  @override
  String get historyTitle => 'Historial';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get addSmartNote => 'Nuevo Paquete';

  @override
  String get noItemsInBundle => 'Sin ítems en este paquete';

  @override
  String payAmount(String amount) {
    return 'Pagar $amount';
  }

  @override
  String get paidAndCompleted => 'Pagado y Completado';

  @override
  String get undoPay => 'Deshacer Pago';

  @override
  String get deleteSmartNoteTitle => '¿Eliminar Paquete?';

  @override
  String confirmPaymentMessage(String amount) {
    return '¿Crear transacción por $amount?';
  }

  @override
  String get paymentSuccess => '¡Pagado y Completado!';

  @override
  String get undoPaymentTitle => '¿Deshacer Pago?';

  @override
  String get undoPaymentConfirm =>
      'Esto eliminará la transacción, reembolsará la billetera y reabrirá el paquete.';

  @override
  String get undoAndReopen => 'Deshacer y Reabrir';

  @override
  String get purchaseReopened => 'Compra Reabierta';

  @override
  String get editSmartNote => 'Editar Paquete';

  @override
  String get newSmartNote => 'Nuevo Paquete';

  @override
  String get smartNoteName => 'Nombre del Paquete';

  @override
  String get smartNoteNameHint => 'ej. Compras del Mes';

  @override
  String get itemsList => 'Lista de Ítems';

  @override
  String get addItem => 'Añadir Ítem';

  @override
  String get requiredShort => 'Req';

  @override
  String get additionalNotes => 'Notas Adicionales';

  @override
  String get totalEstimate => 'Estimado Total';

  @override
  String get saveBundle => 'Guardar Paquete';

  @override
  String get checkedTotal => 'Total Marcado:';

  @override
  String get completed => 'Completado';

  @override
  String get payAndFinish => 'Pagar y Finalizar';

  @override
  String get payingWith => 'Pagando con';

  @override
  String get noItemsChecked => '¡Ningún ítem marcado!';

  @override
  String get smartNoteTransactionRecorded => '¡Transacción registrada!';

  @override
  String get totalDreamValue => 'Valor Total de Sueños';

  @override
  String activeWishesCount(int count) {
    return '$count Deseos';
  }

  @override
  String achievedDreamsCount(int count) {
    return '¡$count Sueños Logrados! 🎉';
  }

  @override
  String get billDataNotFound => 'Datos de factura no encontrados';

  @override
  String get wishlistDataNotFound => 'Datos de lista no encontrados';

  @override
  String get editReimbursementNotSupported =>
      'Edición de reembolso no soportada aún';

  @override
  String get transactions => 'Transacciones';

  @override
  String get noTransactionsFound => 'No se encontraron transacciones';

  @override
  String get noTransactionsInCategory => 'Sin transacciones en esta categoría';

  @override
  String get noDataForPeriod => 'Sin datos para este período';

  @override
  String get monthlyOverview => 'Resumen Mensual';

  @override
  String get unlockPremiumStats => 'Desbloquear Estadísticas Premium';

  @override
  String get totalBalance => 'Balance Total';

  @override
  String get dailyBudget => 'Presupuesto Diario';

  @override
  String get weeklyBudget => 'Presupuesto Semanal';

  @override
  String get monthlyBudget => 'Presupuesto Mensual';

  @override
  String get yearlyBudget => 'Presupuesto Anual';

  @override
  String get wishlistPurchase => 'Compra de Lista de Deseos';

  @override
  String get billPayment => 'Pago de Factura';

  @override
  String get debtTransaction => 'Transacción de Deuda';

  @override
  String get savingsTransaction => 'Transacción de Ahorro';

  @override
  String get transferTransaction => 'Transferencia';

  @override
  String get pressBackAgainToExit => 'Presione atrás de nuevo para salir';

  @override
  String get quickRecord => 'Registro Rápido';

  @override
  String get chatAction => 'Chat';

  @override
  String get scanAction => 'Escanear';

  @override
  String get voiceAction => 'Voz';

  @override
  String get filterDay => 'Día';

  @override
  String get filterWeek => 'Semana';

  @override
  String get filterMonth => 'Mes';

  @override
  String get filterYear => 'Año';

  @override
  String get filterAll => 'Todo';

  @override
  String get editTransaction => 'Editar Transacción';

  @override
  String get addTransaction => 'Añadir Transacción';

  @override
  String get titleLabel => 'Título';

  @override
  String get enterDescriptionHint => 'Ingrese descripción';

  @override
  String get enterTitleHint => 'Ingrese título (ej. Desayuno)';

  @override
  String get enterValidAmount => 'Ingrese un monto válido';

  @override
  String get selectWalletError => 'Seleccione una billetera';

  @override
  String get selectDestinationWalletError => 'Seleccione billetera destino';

  @override
  String get selectCategoryError => 'Seleccione categoría';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get loading => 'Cargando...';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get expenseDetails => 'Detalles de Gasto';

  @override
  String get incomeDetails => 'Detalles de Ingreso';

  @override
  String get noExpensesFound => 'No se encontraron gastos';

  @override
  String get noIncomeFound => 'No se encontraron ingresos';

  @override
  String get forThisDate => 'para esta fecha';

  @override
  String get timeFilterToday => 'Hoy';

  @override
  String get timeFilterThisWeek => 'Esta Semana';

  @override
  String get timeFilterThisMonth => 'Este Mes';

  @override
  String get timeFilterThisYear => 'Este Año';

  @override
  String get timeFilterAllTime => 'Todo el Tiempo';

  @override
  String get dailyAverage => 'Promedio Diario';

  @override
  String get projectedTotal => 'Total Proyectado';

  @override
  String get spendingHabitsNote => 'Basado en sus hábitos de este mes.';

  @override
  String get monthlyComparison => 'Comparación Mensual';

  @override
  String get spendingLessNote => '¡Estás gastando menos que el mes pasado!';

  @override
  String get spendingMoreNote => 'El gasto es mayor de lo usual.';

  @override
  String get topSpenders => 'Mayores Gastos';

  @override
  String transactionsCount(int count) {
    return '$count transacciones';
  }

  @override
  String get activityHeatmap => 'Mapa de Calor';

  @override
  String get less => 'Menos';

  @override
  String get more => 'Más';

  @override
  String get backupRecoveryTitle => 'Respaldo y Recuperación';

  @override
  String get backupDescription =>
      'Asegure sus datos creando un archivo de respaldo local (JSON).';

  @override
  String get createBackup => 'Crear Respaldo';

  @override
  String get restoreBackup => 'Restaurar Respaldo';

  @override
  String get createBackupSubtitle => 'Exportar todo a JSON';

  @override
  String get restoreBackupSubtitle =>
      'Importar desde JSON (Borra datos actuales)';

  @override
  String get creatingBackup => 'Creando respaldo...';

  @override
  String get restoringBackup => 'Restaurando...';

  @override
  String backupSuccess(String path) {
    return 'Respaldo guardado en:\n$path';
  }

  @override
  String get restoreSuccess => '¡Restaurado con éxito! Reinicie la app.';

  @override
  String backupError(String error) {
    return 'Error al crear respaldo: $error';
  }

  @override
  String restoreError(String error) {
    return 'Error al restaurar: $error';
  }

  @override
  String get restoreWarningTitle => '⚠ Advertencia: Restaurar Datos';

  @override
  String get restoreWarningMessage =>
      'Restaurar un respaldo ELIMINARÁ TODOS los datos actuales. ¿Está seguro?';

  @override
  String get yesRestore => 'Sí, Restaurar';

  @override
  String get exportDataTitle => 'Exportar Datos';

  @override
  String get dateRange => 'Rango de Fechas';

  @override
  String get transactionType => 'Tipo de Transacción';

  @override
  String get allWallets => 'Todas las Billeteras';

  @override
  String get allCategories => 'Todas las Categorías';

  @override
  String shareCsv(int count) {
    return 'Compartir CSV ($count ítems)';
  }

  @override
  String get saveToDownloads => 'Guardar en Descargas';

  @override
  String get calculating => 'Calculando...';

  @override
  String get noTransactionsMatch => 'No coinciden transacciones';

  @override
  String exportFailed(String error) {
    return 'Falló exportación: $error';
  }

  @override
  String saveFailed(String error) {
    return 'Falló guardado: $error';
  }

  @override
  String fileSavedTo(String path) {
    return 'Guardado en: $path';
  }

  @override
  String get lastMonth => 'Mes Pasado';

  @override
  String get sendFeedbackTitle => 'Enviar Comentarios';

  @override
  String get weValueYourVoice => 'Valoramos su opinión';

  @override
  String get feedbackDescription =>
      '¿Tiene una idea o encontró un error? ¡Queremos escucharle!';

  @override
  String get chatViaWhatsApp => 'Chat por WhatsApp';

  @override
  String get repliesInHours => 'Responde en pocas horas';

  @override
  String subCategoriesCount(int count) {
    return 'Subcategorías: $count';
  }

  @override
  String get unnamed => 'Sin Nombre';

  @override
  String get ok => 'OK';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get whatsappMessage => 'Hola Equipo Ollo, quiero dar feedback...';

  @override
  String get roadmapTitle => 'Hoja de Ruta';

  @override
  String get roadmapInProgress => 'En Progreso';

  @override
  String get roadmapPlanned => 'Planeado';

  @override
  String get roadmapCompleted => 'Completado';

  @override
  String get roadmapHighPriority => 'Alta Prioridad';

  @override
  String get roadmapBeta => 'BETA';

  @override
  String get roadmapDev => 'Desarrollo';

  @override
  String get featureCloudBackupTitle => 'Respaldo en Nube';

  @override
  String get featureCloudBackupDesc => 'Sincronización con Google Drive';

  @override
  String get featureAiInsightsTitle => 'IA Avanzada';

  @override
  String get featureAiInsightsDesc => 'Análisis profundo de gastos';

  @override
  String get featureDataExportTitle => 'Exportar a Excel';

  @override
  String get featureDataExportDesc => 'CSV/Excel para análisis externo';

  @override
  String get featureBudgetForecastingTitle => 'Pronóstico de Presupuesto';

  @override
  String get featureBudgetForecastingDesc => 'Predecir gastos del próximo mes';

  @override
  String get featureMultiCurrencyTitle => 'Multimoneda';

  @override
  String get featureMultiCurrencyDesc => 'Conversión en tiempo real';

  @override
  String get featureReceiptScanningTitle => 'Escaneo de Recibos (OCR)';

  @override
  String get featureReceiptScanningDesc => 'Escanee recibos para autocompletar';

  @override
  String get featureLocalBackupTitle => 'Respaldo Local';

  @override
  String get featureLocalBackupDesc => 'Guardar todo en un archivo';

  @override
  String get featureSmartNotesTitle => 'Notas Inteligentes';

  @override
  String get featureSmartNotesDesc => 'Listas de compras con cálculo';

  @override
  String get featureRecurringTitle => 'Transacciones Recurrentes';

  @override
  String get featureRecurringDesc => 'Automatizar facturas y salarios';

  @override
  String get aboutTitle => 'Sobre Ollo';

  @override
  String get aboutPhilosophyTitle => 'Su Compañero Financiero';

  @override
  String get aboutPhilosophyDesc =>
      'Ollo nace para simplificar la gestión financiera.';

  @override
  String get connectWithUs => 'Conéctese con nosotros';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get helpTitle => 'Ayuda';

  @override
  String get helpIntroTitle => '¿Cómo podemos ayudarle?';

  @override
  String get helpIntroDesc => 'Preguntas frecuentes o soporte';

  @override
  String get faqTitle => 'Preguntas Frecuentes';

  @override
  String get faqAddWalletQuestion => '¿Cómo añadir una billetera?';

  @override
  String get faqAddWalletAnswer =>
      'Vaya al menú \"Billeteras\" y toque el botón \"+\".';

  @override
  String get faqExportDataQuestion => '¿Puedo exportar mis datos?';

  @override
  String get faqExportDataAnswer => 'Próximamente como función Premium.';

  @override
  String get faqResetDataQuestion => 'How do I reset my data?';

  @override
  String get faqResetDataAnswer =>
      'Currently, you can delete individual transactions or wallets. A full factory reset option will be available in the Settings menu in a future update.';

  @override
  String get faqSecureDataQuestion => 'Is my data secure?';

  @override
  String get faqSecureDataAnswer =>
      'Yes, all your data is stored locally on your device. We do not upload your personal financial data to any external servers.';

  @override
  String get contactSupport => 'Contactar Soporte';

  @override
  String get reimbursementTitle => 'Reembolso';

  @override
  String get reimbursementPending => 'Pendiente';

  @override
  String get reimbursementCompleted => 'Completado';

  @override
  String get noPendingReimbursements => 'Sin reembolsos pendientes';

  @override
  String get noCompletedReimbursements => 'Sin reembolsos completados';

  @override
  String get markPaid => 'Marcar Pagado';

  @override
  String get totalSavings => 'Total Ahorros';

  @override
  String get financialBuckets => 'Buckets Financieros';

  @override
  String get noSavingsYet => 'Sin ahorros';

  @override
  String growthThisMonth(String percent) {
    return '$percent% este mes';
  }

  @override
  String get myCards => 'Mis Tarjetas';

  @override
  String selectedCount(int count) {
    return '$count Seleccionadas';
  }

  @override
  String get copyNumber => 'Copiar Número';

  @override
  String get copyTemplate => 'Copiar Plantilla';

  @override
  String cardsCopied(int count) {
    return '¡$count copiadas!';
  }

  @override
  String get cardNumberCopied => '¡Número copiado!';

  @override
  String get cardTemplateCopied => '¡Plantilla copiada!';

  @override
  String get noCardsYet => 'Sin tarjetas';

  @override
  String get addCardsMessage => 'Añada cuentas o tarjetas';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumSubtitle => 'Desbloquee todo el potencial.';

  @override
  String get premiumAdvancedStats => 'Estadísticas Avanzadas';

  @override
  String get premiumAdvancedStatsDesc => 'Gráficos interactivos';

  @override
  String get premiumDataExport => 'Exportar Datos';

  @override
  String get premiumDataExportDesc => 'Respaldo en CSV/Excel';

  @override
  String get premiumUnlimitedWallets => 'Billeteras Ilimitadas';

  @override
  String get premiumUnlimitedWalletsDesc => 'Cree tantas como necesite';

  @override
  String get premiumSmartAlerts => 'Alertas Inteligentes';

  @override
  String get premiumSmartAlertsDesc => 'Evite gastar de más';

  @override
  String get upgradeButton => 'Mejorar - Rp 29.000 / Vida';

  @override
  String get restorePurchase => 'Restaurar Compra';

  @override
  String get youArePremium => '¡Eres Premium!';

  @override
  String get premiumWelcome => '¡Bienvenido a Premium! 🌟';

  @override
  String get contactSupportMessage => 'Hola Soporte Ollo...';

  @override
  String get category_food => 'Comida y Bebida';

  @override
  String get category_transport => 'Transporte';

  @override
  String get category_shopping => 'Compras';

  @override
  String get category_housing => 'Vivienda';

  @override
  String get category_entertainment => 'Entretenimiento';

  @override
  String get category_health => 'Salud';

  @override
  String get category_education => 'Educación';

  @override
  String get category_personal => 'Personal';

  @override
  String get category_financial => 'Financiero';

  @override
  String get category_family => 'Familia';

  @override
  String get category_salary => 'Salario';

  @override
  String get category_business => 'Negocios';

  @override
  String get category_investments => 'Inversiones';

  @override
  String get category_gifts_income => 'Regalos';

  @override
  String get category_other_income => 'Otros';

  @override
  String get subcategory_breakfast => 'Desayuno';

  @override
  String get subcategory_lunch => 'Almuerzo';

  @override
  String get subcategory_dinner => 'Cena';

  @override
  String get subcategory_eateries => 'Restaurantes';

  @override
  String get subcategory_snacks => 'Merienda';

  @override
  String get subcategory_drinks => 'Bebidas';

  @override
  String get subcategory_groceries => 'Supermercado';

  @override
  String get subcategory_delivery => 'Delivery';

  @override
  String get subcategory_alcohol => 'Alcohol';

  @override
  String get subcategory_bus => 'Autobús';

  @override
  String get subcategory_train => 'Tren';

  @override
  String get subcategory_taxi => 'Taxi';

  @override
  String get subcategory_fuel => 'Gasolina';

  @override
  String get subcategory_parking => 'Estacionamiento';

  @override
  String get subcategory_maintenance => 'Mantenimiento';

  @override
  String get subcategory_insurance_car => 'Seguro';

  @override
  String get subcategory_toll => 'Peaje';

  @override
  String get subcategory_clothes => 'Ropa';

  @override
  String get subcategory_electronics => 'Electrónica';

  @override
  String get subcategory_home => 'Hogar';

  @override
  String get subcategory_beauty => 'Belleza';

  @override
  String get subcategory_gifts => 'Regalos';

  @override
  String get subcategory_software => 'Software';

  @override
  String get subcategory_tools => 'Herramientas';

  @override
  String get subcategory_rent => 'Alquiler';

  @override
  String get subcategory_mortgage => 'Hipoteca';

  @override
  String get subcategory_utilities => 'Servicios';

  @override
  String get subcategory_internet => 'Internet';

  @override
  String get subcategory_maintenance_home => 'Mantenimiento Hogar';

  @override
  String get subcategory_furniture => 'Muebles';

  @override
  String get subcategory_services => 'Servicios';

  @override
  String get subcategory_movies => 'Cine';

  @override
  String get subcategory_games => 'Juegos';

  @override
  String get subcategory_streaming => 'Streaming';

  @override
  String get subcategory_events => 'Eventos';

  @override
  String get subcategory_hobbies => 'Pasatiempos';

  @override
  String get subcategory_travel => 'Viajes';

  @override
  String get monthlyCommitment => 'Monthly Commitment';

  @override
  String get upcomingBill => 'Upcoming Bill';

  @override
  String get noUpcomingBills => 'No upcoming bills';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String inDays(Object days) {
    return 'In $days days';
  }

  @override
  String get needTwoWallets => 'Need 2+ wallets';

  @override
  String get nettBalance => 'Nett Balance';

  @override
  String get activeDebt => 'Active Debt';

  @override
  String get last30Days => 'last 30 days';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get unlimitedAccess => 'You have unlimited access!';

  @override
  String get unlockFeatures => 'Unlock all features & remove limits.';

  @override
  String get from => 'From';

  @override
  String get subcategory_music => 'Música';

  @override
  String get subcategory_doctor => 'Médico';

  @override
  String get subcategory_pharmacy => 'Farmacia';

  @override
  String get subcategory_gym => 'Gimnasio';

  @override
  String get subcategory_insurance_health => 'Seguro Salud';

  @override
  String get subcategory_mental_health => 'Salud Mental';

  @override
  String get subcategory_sports => 'Deportes';

  @override
  String get subcategory_tuition => 'Matrícula';

  @override
  String get subcategory_books => 'Libros';

  @override
  String get subcategory_courses => 'Cursos';

  @override
  String get subcategory_supplies => 'Útiles';

  @override
  String get subcategory_haircut => 'Corte de Pelo';

  @override
  String get subcategory_spa => 'Spa';

  @override
  String get subcategory_cosmetics => 'Cosméticos';

  @override
  String get subcategory_taxes => 'Impuestos';

  @override
  String get subcategory_fees => 'Tarifas';

  @override
  String get subcategory_fines => 'Multas';

  @override
  String get subcategory_insurance_life => 'Seguro Vida';

  @override
  String get subcategory_childcare => 'Cuidado Niños';

  @override
  String get subcategory_toys => 'Juguetes';

  @override
  String get subcategory_school_kids => 'Escuela';

  @override
  String get subcategory_pets => 'Mascotas';

  @override
  String get subcategory_monthly => 'Mensual';

  @override
  String get subcategory_weekly => 'Semanal';

  @override
  String get subcategory_bonus => 'Bono';

  @override
  String get subcategory_overtime => 'Horas Extras';

  @override
  String get subcategory_sales => 'Ventas';

  @override
  String get subcategory_profit => 'Ganancia';

  @override
  String get subcategory_dividends => 'Dividendos';

  @override
  String get subcategory_interest => 'Interés';

  @override
  String get subcategory_crypto => 'Cripto';

  @override
  String get subcategory_stocks => 'Acciones';

  @override
  String get subcategory_real_estate => 'Inmobiliaria';

  @override
  String get subcategory_birthday => 'Cumpleaños';

  @override
  String get subcategory_holiday => 'Feriado';

  @override
  String get subcategory_allowance => 'Mesada';

  @override
  String get subcategory_refunds => 'Reembolso';

  @override
  String get subcategory_grants => 'Subvenciones';

  @override
  String get subcategory_lottery => 'Lotería';

  @override
  String get subcategory_selling => 'Venta';

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get emailLabel => 'Email (Opcional)';

  @override
  String get uploadPhoto => 'Subir Foto';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get listeningMessage => 'Ollo está escuchando...';

  @override
  String get quickRecordTitle => 'Registro Rápido';

  @override
  String get saySomethingHint => 'Diga \"Almuerzo 10 euros\"...';

  @override
  String get stopAndProcess => 'Parar y Procesar';

  @override
  String get textInputHint => 'ej. \"Almuerzo 10 euros\"';

  @override
  String get draftReady => 'Borrador Listo';

  @override
  String get saveAdjust => 'Guardar / Ajustar';

  @override
  String get notFound => 'No encontrado';

  @override
  String get selectWallet => 'Seleccionar Billetera';
}
