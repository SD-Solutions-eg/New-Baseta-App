class PayTabsModel {
  final String profileId;
  final String serverKey;
  final String clientKey;

  PayTabsModel({
    this.profileId = '92709',
    this.serverKey = 'S2JN2TNNZ2-JDGZGWMMW2-JZNBNRRHR2',
    this.clientKey = 'CQKMQG-2BHH6D-T9TVNN-HQ9TNH',
  });

  factory PayTabsModel.fromMap(Map<String, dynamic> map) {
    return PayTabsModel(
      profileId: map['profile_id'] as String? ?? '92709',
      serverKey:
          map['server_key'] as String? ?? 'S2JN2TNNZ2-JDGZGWMMW2-JZNBNRRHR2',
      clientKey: map['client_key'] as String? ?? 'CQKMQG-2BHH6D-T9TVNN-HQ9TNH',
    );
  }
}
