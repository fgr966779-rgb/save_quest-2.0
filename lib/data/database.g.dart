// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<int> currentAmount = GeneratedColumn<int>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accentColorMeta =
      const VerificationMeta('accentColor');
  @override
  late final GeneratedColumn<String> accentColor = GeneratedColumn<String>(
      'accent_color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _productUrlMeta =
      const VerificationMeta('productUrl');
  @override
  late final GeneratedColumn<String> productUrl = GeneratedColumn<String>(
      'product_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetPriceMeta =
      const VerificationMeta('targetPrice');
  @override
  late final GeneratedColumn<int> targetPrice = GeneratedColumn<int>(
      'target_price', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentPriceMeta =
      const VerificationMeta('currentPrice');
  @override
  late final GeneratedColumn<int> currentPrice = GeneratedColumn<int>(
      'current_price', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _priceShieldHpMeta =
      const VerificationMeta('priceShieldHp');
  @override
  late final GeneratedColumn<int> priceShieldHp = GeneratedColumn<int>(
      'price_shield_hp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _lastPriceUpdateMeta =
      const VerificationMeta('lastPriceUpdate');
  @override
  late final GeneratedColumn<DateTime> lastPriceUpdate =
      GeneratedColumn<DateTime>('last_price_update', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        targetAmount,
        currentAmount,
        currency,
        accentColor,
        createdAt,
        updatedAt,
        productUrl,
        targetPrice,
        currentPrice,
        priceShieldHp,
        lastPriceUpdate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('accent_color')) {
      context.handle(
          _accentColorMeta,
          accentColor.isAcceptableOrUnknown(
              data['accent_color']!, _accentColorMeta));
    } else if (isInserting) {
      context.missing(_accentColorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('product_url')) {
      context.handle(
          _productUrlMeta,
          productUrl.isAcceptableOrUnknown(
              data['product_url']!, _productUrlMeta));
    }
    if (data.containsKey('target_price')) {
      context.handle(
          _targetPriceMeta,
          targetPrice.isAcceptableOrUnknown(
              data['target_price']!, _targetPriceMeta));
    }
    if (data.containsKey('current_price')) {
      context.handle(
          _currentPriceMeta,
          currentPrice.isAcceptableOrUnknown(
              data['current_price']!, _currentPriceMeta));
    }
    if (data.containsKey('price_shield_hp')) {
      context.handle(
          _priceShieldHpMeta,
          priceShieldHp.isAcceptableOrUnknown(
              data['price_shield_hp']!, _priceShieldHpMeta));
    }
    if (data.containsKey('last_price_update')) {
      context.handle(
          _lastPriceUpdateMeta,
          lastPriceUpdate.isAcceptableOrUnknown(
              data['last_price_update']!, _lastPriceUpdateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      accentColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}accent_color'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      productUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_url']),
      targetPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_price']),
      currentPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_price']),
      priceShieldHp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_shield_hp'])!,
      lastPriceUpdate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_price_update']),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String name;

  /// Target amount in minor units (kopecks).
  final int targetAmount;

  /// Current accumulated amount in minor units (kopecks).
  final int currentAmount;
  final String currency;
  final String accentColor;
  final DateTime createdAt;

  /// Sync-readiness: updated on every write for Last-Write-Wins conflict resolution.
  final DateTime updatedAt;
  final String? productUrl;
  final int? targetPrice;
  final int? currentPrice;
  final int priceShieldHp;
  final DateTime? lastPriceUpdate;
  const Goal(
      {required this.id,
      required this.name,
      required this.targetAmount,
      required this.currentAmount,
      required this.currency,
      required this.accentColor,
      required this.createdAt,
      required this.updatedAt,
      this.productUrl,
      this.targetPrice,
      this.currentPrice,
      required this.priceShieldHp,
      this.lastPriceUpdate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<int>(targetAmount);
    map['current_amount'] = Variable<int>(currentAmount);
    map['currency'] = Variable<String>(currency);
    map['accent_color'] = Variable<String>(accentColor);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || productUrl != null) {
      map['product_url'] = Variable<String>(productUrl);
    }
    if (!nullToAbsent || targetPrice != null) {
      map['target_price'] = Variable<int>(targetPrice);
    }
    if (!nullToAbsent || currentPrice != null) {
      map['current_price'] = Variable<int>(currentPrice);
    }
    map['price_shield_hp'] = Variable<int>(priceShieldHp);
    if (!nullToAbsent || lastPriceUpdate != null) {
      map['last_price_update'] = Variable<DateTime>(lastPriceUpdate);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      currency: Value(currency),
      accentColor: Value(accentColor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      productUrl: productUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(productUrl),
      targetPrice: targetPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPrice),
      currentPrice: currentPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPrice),
      priceShieldHp: Value(priceShieldHp),
      lastPriceUpdate: lastPriceUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPriceUpdate),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      currentAmount: serializer.fromJson<int>(json['currentAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      accentColor: serializer.fromJson<String>(json['accentColor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      productUrl: serializer.fromJson<String?>(json['productUrl']),
      targetPrice: serializer.fromJson<int?>(json['targetPrice']),
      currentPrice: serializer.fromJson<int?>(json['currentPrice']),
      priceShieldHp: serializer.fromJson<int>(json['priceShieldHp']),
      lastPriceUpdate: serializer.fromJson<DateTime?>(json['lastPriceUpdate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'currentAmount': serializer.toJson<int>(currentAmount),
      'currency': serializer.toJson<String>(currency),
      'accentColor': serializer.toJson<String>(accentColor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'productUrl': serializer.toJson<String?>(productUrl),
      'targetPrice': serializer.toJson<int?>(targetPrice),
      'currentPrice': serializer.toJson<int?>(currentPrice),
      'priceShieldHp': serializer.toJson<int>(priceShieldHp),
      'lastPriceUpdate': serializer.toJson<DateTime?>(lastPriceUpdate),
    };
  }

  Goal copyWith(
          {String? id,
          String? name,
          int? targetAmount,
          int? currentAmount,
          String? currency,
          String? accentColor,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> productUrl = const Value.absent(),
          Value<int?> targetPrice = const Value.absent(),
          Value<int?> currentPrice = const Value.absent(),
          int? priceShieldHp,
          Value<DateTime?> lastPriceUpdate = const Value.absent()}) =>
      Goal(
        id: id ?? this.id,
        name: name ?? this.name,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        currency: currency ?? this.currency,
        accentColor: accentColor ?? this.accentColor,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        productUrl: productUrl.present ? productUrl.value : this.productUrl,
        targetPrice: targetPrice.present ? targetPrice.value : this.targetPrice,
        currentPrice:
            currentPrice.present ? currentPrice.value : this.currentPrice,
        priceShieldHp: priceShieldHp ?? this.priceShieldHp,
        lastPriceUpdate: lastPriceUpdate.present
            ? lastPriceUpdate.value
            : this.lastPriceUpdate,
      );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      accentColor:
          data.accentColor.present ? data.accentColor.value : this.accentColor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      productUrl:
          data.productUrl.present ? data.productUrl.value : this.productUrl,
      targetPrice:
          data.targetPrice.present ? data.targetPrice.value : this.targetPrice,
      currentPrice: data.currentPrice.present
          ? data.currentPrice.value
          : this.currentPrice,
      priceShieldHp: data.priceShieldHp.present
          ? data.priceShieldHp.value
          : this.priceShieldHp,
      lastPriceUpdate: data.lastPriceUpdate.present
          ? data.lastPriceUpdate.value
          : this.lastPriceUpdate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('currency: $currency, ')
          ..write('accentColor: $accentColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('productUrl: $productUrl, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('priceShieldHp: $priceShieldHp, ')
          ..write('lastPriceUpdate: $lastPriceUpdate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      targetAmount,
      currentAmount,
      currency,
      accentColor,
      createdAt,
      updatedAt,
      productUrl,
      targetPrice,
      currentPrice,
      priceShieldHp,
      lastPriceUpdate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.currency == this.currency &&
          other.accentColor == this.accentColor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.productUrl == this.productUrl &&
          other.targetPrice == this.targetPrice &&
          other.currentPrice == this.currentPrice &&
          other.priceShieldHp == this.priceShieldHp &&
          other.lastPriceUpdate == this.lastPriceUpdate);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> targetAmount;
  final Value<int> currentAmount;
  final Value<String> currency;
  final Value<String> accentColor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> productUrl;
  final Value<int?> targetPrice;
  final Value<int?> currentPrice;
  final Value<int> priceShieldHp;
  final Value<DateTime?> lastPriceUpdate;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.productUrl = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.priceShieldHp = const Value.absent(),
    this.lastPriceUpdate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String name,
    required int targetAmount,
    required int currentAmount,
    required String currency,
    required String accentColor,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.productUrl = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.priceShieldHp = const Value.absent(),
    this.lastPriceUpdate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        targetAmount = Value(targetAmount),
        currentAmount = Value(currentAmount),
        currency = Value(currency),
        accentColor = Value(accentColor),
        createdAt = Value(createdAt);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? targetAmount,
    Expression<int>? currentAmount,
    Expression<String>? currency,
    Expression<String>? accentColor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? productUrl,
    Expression<int>? targetPrice,
    Expression<int>? currentPrice,
    Expression<int>? priceShieldHp,
    Expression<DateTime>? lastPriceUpdate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (currency != null) 'currency': currency,
      if (accentColor != null) 'accent_color': accentColor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (productUrl != null) 'product_url': productUrl,
      if (targetPrice != null) 'target_price': targetPrice,
      if (currentPrice != null) 'current_price': currentPrice,
      if (priceShieldHp != null) 'price_shield_hp': priceShieldHp,
      if (lastPriceUpdate != null) 'last_price_update': lastPriceUpdate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? targetAmount,
      Value<int>? currentAmount,
      Value<String>? currency,
      Value<String>? accentColor,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? productUrl,
      Value<int?>? targetPrice,
      Value<int?>? currentPrice,
      Value<int>? priceShieldHp,
      Value<DateTime?>? lastPriceUpdate,
      Value<int>? rowid}) {
    return GoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      currency: currency ?? this.currency,
      accentColor: accentColor ?? this.accentColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productUrl: productUrl ?? this.productUrl,
      targetPrice: targetPrice ?? this.targetPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      priceShieldHp: priceShieldHp ?? this.priceShieldHp,
      lastPriceUpdate: lastPriceUpdate ?? this.lastPriceUpdate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<int>(currentAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<String>(accentColor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (productUrl.present) {
      map['product_url'] = Variable<String>(productUrl.value);
    }
    if (targetPrice.present) {
      map['target_price'] = Variable<int>(targetPrice.value);
    }
    if (currentPrice.present) {
      map['current_price'] = Variable<int>(currentPrice.value);
    }
    if (priceShieldHp.present) {
      map['price_shield_hp'] = Variable<int>(priceShieldHp.value);
    }
    if (lastPriceUpdate.present) {
      map['last_price_update'] = Variable<DateTime>(lastPriceUpdate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('currency: $currency, ')
          ..write('accentColor: $accentColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('productUrl: $productUrl, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('priceShieldHp: $priceShieldHp, ')
          ..write('lastPriceUpdate: $lastPriceUpdate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepositsTable extends Deposits with TableInfo<$DepositsTable, Deposit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, note, createdAt, updatedAt, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deposits';
  @override
  VerificationContext validateIntegrity(Insertable<Deposit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deposit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deposit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $DepositsTable createAlias(String alias) {
    return $DepositsTable(attachedDatabase, alias);
  }
}

class Deposit extends DataClass implements Insertable<Deposit> {
  final String id;

  /// Total deposit amount in minor units (kopecks).
  final int amount;
  final String? note;
  final DateTime createdAt;

  /// Sync-readiness: updated on every write for Last-Write-Wins conflict resolution.
  final DateTime updatedAt;
  final bool isDeleted;
  const Deposit(
      {required this.id,
      required this.amount,
      this.note,
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DepositsCompanion toCompanion(bool nullToAbsent) {
    return DepositsCompanion(
      id: Value(id),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Deposit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deposit(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<int>(amount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Deposit copyWith(
          {String? id,
          int? amount,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isDeleted}) =>
      Deposit(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Deposit copyWithCompanion(DepositsCompanion data) {
    return Deposit(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deposit(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, amount, note, createdAt, updatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deposit &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class DepositsCompanion extends UpdateCompanion<Deposit> {
  final Value<String> id;
  final Value<int> amount;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const DepositsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepositsCompanion.insert({
    required String id,
    required int amount,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        amount = Value(amount),
        createdAt = Value(createdAt);
  static Insertable<Deposit> custom({
    Expression<String>? id,
    Expression<int>? amount,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepositsCompanion copyWith(
      {Value<String>? id,
      Value<int>? amount,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return DepositsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepositAllocationsTable extends DepositAllocations
    with TableInfo<$DepositAllocationsTable, DepositAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depositIdMeta =
      const VerificationMeta('depositId');
  @override
  late final GeneratedColumn<String> depositId = GeneratedColumn<String>(
      'deposit_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES deposits (id)'));
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES goals (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, depositId, goalId, amount, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deposit_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<DepositAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deposit_id')) {
      context.handle(_depositIdMeta,
          depositId.isAcceptableOrUnknown(data['deposit_id']!, _depositIdMeta));
    } else if (isInserting) {
      context.missing(_depositIdMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepositAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepositAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      depositId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deposit_id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DepositAllocationsTable createAlias(String alias) {
    return $DepositAllocationsTable(attachedDatabase, alias);
  }
}

class DepositAllocation extends DataClass
    implements Insertable<DepositAllocation> {
  final String id;
  final String depositId;
  final String goalId;

  /// Allocated portion in minor units (kopecks).
  final int amount;
  final DateTime updatedAt;
  const DepositAllocation(
      {required this.id,
      required this.depositId,
      required this.goalId,
      required this.amount,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deposit_id'] = Variable<String>(depositId);
    map['goal_id'] = Variable<String>(goalId);
    map['amount'] = Variable<int>(amount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DepositAllocationsCompanion toCompanion(bool nullToAbsent) {
    return DepositAllocationsCompanion(
      id: Value(id),
      depositId: Value(depositId),
      goalId: Value(goalId),
      amount: Value(amount),
      updatedAt: Value(updatedAt),
    );
  }

  factory DepositAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepositAllocation(
      id: serializer.fromJson<String>(json['id']),
      depositId: serializer.fromJson<String>(json['depositId']),
      goalId: serializer.fromJson<String>(json['goalId']),
      amount: serializer.fromJson<int>(json['amount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'depositId': serializer.toJson<String>(depositId),
      'goalId': serializer.toJson<String>(goalId),
      'amount': serializer.toJson<int>(amount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DepositAllocation copyWith(
          {String? id,
          String? depositId,
          String? goalId,
          int? amount,
          DateTime? updatedAt}) =>
      DepositAllocation(
        id: id ?? this.id,
        depositId: depositId ?? this.depositId,
        goalId: goalId ?? this.goalId,
        amount: amount ?? this.amount,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DepositAllocation copyWithCompanion(DepositAllocationsCompanion data) {
    return DepositAllocation(
      id: data.id.present ? data.id.value : this.id,
      depositId: data.depositId.present ? data.depositId.value : this.depositId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amount: data.amount.present ? data.amount.value : this.amount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepositAllocation(')
          ..write('id: $id, ')
          ..write('depositId: $depositId, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, depositId, goalId, amount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepositAllocation &&
          other.id == this.id &&
          other.depositId == this.depositId &&
          other.goalId == this.goalId &&
          other.amount == this.amount &&
          other.updatedAt == this.updatedAt);
}

class DepositAllocationsCompanion extends UpdateCompanion<DepositAllocation> {
  final Value<String> id;
  final Value<String> depositId;
  final Value<String> goalId;
  final Value<int> amount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DepositAllocationsCompanion({
    this.id = const Value.absent(),
    this.depositId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepositAllocationsCompanion.insert({
    required String id,
    required String depositId,
    required String goalId,
    required int amount,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        depositId = Value(depositId),
        goalId = Value(goalId),
        amount = Value(amount);
  static Insertable<DepositAllocation> custom({
    Expression<String>? id,
    Expression<String>? depositId,
    Expression<String>? goalId,
    Expression<int>? amount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (depositId != null) 'deposit_id': depositId,
      if (goalId != null) 'goal_id': goalId,
      if (amount != null) 'amount': amount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepositAllocationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? depositId,
      Value<String>? goalId,
      Value<int>? amount,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DepositAllocationsCompanion(
      id: id ?? this.id,
      depositId: depositId ?? this.depositId,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (depositId.present) {
      map['deposit_id'] = Variable<String>(depositId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('depositId: $depositId, ')
          ..write('goalId: $goalId, ')
          ..write('amount: $amount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
      'xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _streakCountMeta =
      const VerificationMeta('streakCount');
  @override
  late final GeneratedColumn<int> streakCount = GeneratedColumn<int>(
      'streak_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxStreakMeta =
      const VerificationMeta('maxStreak');
  @override
  late final GeneratedColumn<int> maxStreak = GeneratedColumn<int>(
      'max_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _freezeTokensMeta =
      const VerificationMeta('freezeTokens');
  @override
  late final GeneratedColumn<int> freezeTokens = GeneratedColumn<int>(
      'freeze_tokens', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastDepositDateMeta =
      const VerificationMeta('lastDepositDate');
  @override
  late final GeneratedColumn<DateTime> lastDepositDate =
      GeneratedColumn<DateTime>('last_deposit_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _skillPointsMeta =
      const VerificationMeta('skillPoints');
  @override
  late final GeneratedColumn<int> skillPoints = GeneratedColumn<int>(
      'skill_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _playerClassMeta =
      const VerificationMeta('playerClass');
  @override
  late final GeneratedColumn<String> playerClass = GeneratedColumn<String>(
      'player_class', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentThemeMeta =
      const VerificationMeta('currentTheme');
  @override
  late final GeneratedColumn<String> currentTheme = GeneratedColumn<String>(
      'current_theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _avatarConfigMeta =
      const VerificationMeta('avatarConfig');
  @override
  late final GeneratedColumn<String> avatarConfig = GeneratedColumn<String>(
      'avatar_config', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _penaltyBalanceMeta =
      const VerificationMeta('penaltyBalance');
  @override
  late final GeneratedColumn<int> penaltyBalance = GeneratedColumn<int>(
      'penalty_balance', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hackerXpMeta =
      const VerificationMeta('hackerXp');
  @override
  late final GeneratedColumn<int> hackerXp = GeneratedColumn<int>(
      'hacker_xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _magnateXpMeta =
      const VerificationMeta('magnateXp');
  @override
  late final GeneratedColumn<int> magnateXp = GeneratedColumn<int>(
      'magnate_xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _resilienceXpMeta =
      const VerificationMeta('resilienceXp');
  @override
  late final GeneratedColumn<int> resilienceXp = GeneratedColumn<int>(
      'resilience_xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastBonusClaimDateMeta =
      const VerificationMeta('lastBonusClaimDate');
  @override
  late final GeneratedColumn<DateTime> lastBonusClaimDate =
      GeneratedColumn<DateTime>('last_bonus_claim_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _bonusStreakMeta =
      const VerificationMeta('bonusStreak');
  @override
  late final GeneratedColumn<int> bonusStreak = GeneratedColumn<int>(
      'bonus_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _crystalsBalanceMeta =
      const VerificationMeta('crystalsBalance');
  @override
  late final GeneratedColumn<int> crystalsBalance = GeneratedColumn<int>(
      'crystals_balance', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noSpendStreakCountMeta =
      const VerificationMeta('noSpendStreakCount');
  @override
  late final GeneratedColumn<int> noSpendStreakCount = GeneratedColumn<int>(
      'no_spend_streak_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastNoSpendDateMeta =
      const VerificationMeta('lastNoSpendDate');
  @override
  late final GeneratedColumn<DateTime> lastNoSpendDate =
      GeneratedColumn<DateTime>('last_no_spend_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _karmaDebtMeta =
      const VerificationMeta('karmaDebt');
  @override
  late final GeneratedColumn<int> karmaDebt = GeneratedColumn<int>(
      'karma_debt', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _debuffActiveUntilMeta =
      const VerificationMeta('debuffActiveUntil');
  @override
  late final GeneratedColumn<DateTime> debuffActiveUntil =
      GeneratedColumn<DateTime>('debuff_active_until', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _partnerNameMeta =
      const VerificationMeta('partnerName');
  @override
  late final GeneratedColumn<String> partnerName = GeneratedColumn<String>(
      'partner_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _partnerLastDepositDateMeta =
      const VerificationMeta('partnerLastDepositDate');
  @override
  late final GeneratedColumn<DateTime> partnerLastDepositDate =
      GeneratedColumn<DateTime>('partner_last_deposit_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastDiversificationXPDateMeta =
      const VerificationMeta('lastDiversificationXPDate');
  @override
  late final GeneratedColumn<DateTime> lastDiversificationXPDate =
      GeneratedColumn<DateTime>(
          'last_diversification_x_p_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastRebalanceXPDateMeta =
      const VerificationMeta('lastRebalanceXPDate');
  @override
  late final GeneratedColumn<DateTime> lastRebalanceXPDate =
      GeneratedColumn<DateTime>('last_rebalance_x_p_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastPricePulseXPDateMeta =
      const VerificationMeta('lastPricePulseXPDate');
  @override
  late final GeneratedColumn<DateTime> lastPricePulseXPDate =
      GeneratedColumn<DateTime>('last_price_pulse_x_p_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _pricePulseTrackingCountMeta =
      const VerificationMeta('pricePulseTrackingCount');
  @override
  late final GeneratedColumn<int> pricePulseTrackingCount =
      GeneratedColumn<int>('price_pulse_tracking_count', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _karmaHealingStreakCountMeta =
      const VerificationMeta('karmaHealingStreakCount');
  @override
  late final GeneratedColumn<int> karmaHealingStreakCount =
      GeneratedColumn<int>('karma_healing_streak_count', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _lastKarmaHealDateMeta =
      const VerificationMeta('lastKarmaHealDate');
  @override
  late final GeneratedColumn<DateTime> lastKarmaHealDate =
      GeneratedColumn<DateTime>('last_karma_heal_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        xp,
        level,
        streakCount,
        maxStreak,
        freezeTokens,
        lastDepositDate,
        skillPoints,
        playerClass,
        currentTheme,
        avatarConfig,
        penaltyBalance,
        hackerXp,
        magnateXp,
        resilienceXp,
        lastBonusClaimDate,
        bonusStreak,
        crystalsBalance,
        noSpendStreakCount,
        lastNoSpendDate,
        updatedAt,
        karmaDebt,
        debuffActiveUntil,
        partnerName,
        partnerLastDepositDate,
        lastDiversificationXPDate,
        lastRebalanceXPDate,
        lastPricePulseXPDate,
        pricePulseTrackingCount,
        karmaHealingStreakCount,
        lastKarmaHealDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('streak_count')) {
      context.handle(
          _streakCountMeta,
          streakCount.isAcceptableOrUnknown(
              data['streak_count']!, _streakCountMeta));
    }
    if (data.containsKey('max_streak')) {
      context.handle(_maxStreakMeta,
          maxStreak.isAcceptableOrUnknown(data['max_streak']!, _maxStreakMeta));
    }
    if (data.containsKey('freeze_tokens')) {
      context.handle(
          _freezeTokensMeta,
          freezeTokens.isAcceptableOrUnknown(
              data['freeze_tokens']!, _freezeTokensMeta));
    }
    if (data.containsKey('last_deposit_date')) {
      context.handle(
          _lastDepositDateMeta,
          lastDepositDate.isAcceptableOrUnknown(
              data['last_deposit_date']!, _lastDepositDateMeta));
    }
    if (data.containsKey('skill_points')) {
      context.handle(
          _skillPointsMeta,
          skillPoints.isAcceptableOrUnknown(
              data['skill_points']!, _skillPointsMeta));
    }
    if (data.containsKey('player_class')) {
      context.handle(
          _playerClassMeta,
          playerClass.isAcceptableOrUnknown(
              data['player_class']!, _playerClassMeta));
    }
    if (data.containsKey('current_theme')) {
      context.handle(
          _currentThemeMeta,
          currentTheme.isAcceptableOrUnknown(
              data['current_theme']!, _currentThemeMeta));
    }
    if (data.containsKey('avatar_config')) {
      context.handle(
          _avatarConfigMeta,
          avatarConfig.isAcceptableOrUnknown(
              data['avatar_config']!, _avatarConfigMeta));
    }
    if (data.containsKey('penalty_balance')) {
      context.handle(
          _penaltyBalanceMeta,
          penaltyBalance.isAcceptableOrUnknown(
              data['penalty_balance']!, _penaltyBalanceMeta));
    }
    if (data.containsKey('hacker_xp')) {
      context.handle(_hackerXpMeta,
          hackerXp.isAcceptableOrUnknown(data['hacker_xp']!, _hackerXpMeta));
    }
    if (data.containsKey('magnate_xp')) {
      context.handle(_magnateXpMeta,
          magnateXp.isAcceptableOrUnknown(data['magnate_xp']!, _magnateXpMeta));
    }
    if (data.containsKey('resilience_xp')) {
      context.handle(
          _resilienceXpMeta,
          resilienceXp.isAcceptableOrUnknown(
              data['resilience_xp']!, _resilienceXpMeta));
    }
    if (data.containsKey('last_bonus_claim_date')) {
      context.handle(
          _lastBonusClaimDateMeta,
          lastBonusClaimDate.isAcceptableOrUnknown(
              data['last_bonus_claim_date']!, _lastBonusClaimDateMeta));
    }
    if (data.containsKey('bonus_streak')) {
      context.handle(
          _bonusStreakMeta,
          bonusStreak.isAcceptableOrUnknown(
              data['bonus_streak']!, _bonusStreakMeta));
    }
    if (data.containsKey('crystals_balance')) {
      context.handle(
          _crystalsBalanceMeta,
          crystalsBalance.isAcceptableOrUnknown(
              data['crystals_balance']!, _crystalsBalanceMeta));
    }
    if (data.containsKey('no_spend_streak_count')) {
      context.handle(
          _noSpendStreakCountMeta,
          noSpendStreakCount.isAcceptableOrUnknown(
              data['no_spend_streak_count']!, _noSpendStreakCountMeta));
    }
    if (data.containsKey('last_no_spend_date')) {
      context.handle(
          _lastNoSpendDateMeta,
          lastNoSpendDate.isAcceptableOrUnknown(
              data['last_no_spend_date']!, _lastNoSpendDateMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('karma_debt')) {
      context.handle(_karmaDebtMeta,
          karmaDebt.isAcceptableOrUnknown(data['karma_debt']!, _karmaDebtMeta));
    }
    if (data.containsKey('debuff_active_until')) {
      context.handle(
          _debuffActiveUntilMeta,
          debuffActiveUntil.isAcceptableOrUnknown(
              data['debuff_active_until']!, _debuffActiveUntilMeta));
    }
    if (data.containsKey('partner_name')) {
      context.handle(
          _partnerNameMeta,
          partnerName.isAcceptableOrUnknown(
              data['partner_name']!, _partnerNameMeta));
    }
    if (data.containsKey('partner_last_deposit_date')) {
      context.handle(
          _partnerLastDepositDateMeta,
          partnerLastDepositDate.isAcceptableOrUnknown(
              data['partner_last_deposit_date']!, _partnerLastDepositDateMeta));
    }
    if (data.containsKey('last_diversification_x_p_date')) {
      context.handle(
          _lastDiversificationXPDateMeta,
          lastDiversificationXPDate.isAcceptableOrUnknown(
              data['last_diversification_x_p_date']!,
              _lastDiversificationXPDateMeta));
    }
    if (data.containsKey('last_rebalance_x_p_date')) {
      context.handle(
          _lastRebalanceXPDateMeta,
          lastRebalanceXPDate.isAcceptableOrUnknown(
              data['last_rebalance_x_p_date']!, _lastRebalanceXPDateMeta));
    }
    if (data.containsKey('last_price_pulse_x_p_date')) {
      context.handle(
          _lastPricePulseXPDateMeta,
          lastPricePulseXPDate.isAcceptableOrUnknown(
              data['last_price_pulse_x_p_date']!, _lastPricePulseXPDateMeta));
    }
    if (data.containsKey('price_pulse_tracking_count')) {
      context.handle(
          _pricePulseTrackingCountMeta,
          pricePulseTrackingCount.isAcceptableOrUnknown(
              data['price_pulse_tracking_count']!,
              _pricePulseTrackingCountMeta));
    }
    if (data.containsKey('karma_healing_streak_count')) {
      context.handle(
          _karmaHealingStreakCountMeta,
          karmaHealingStreakCount.isAcceptableOrUnknown(
              data['karma_healing_streak_count']!,
              _karmaHealingStreakCountMeta));
    }
    if (data.containsKey('last_karma_heal_date')) {
      context.handle(
          _lastKarmaHealDateMeta,
          lastKarmaHealDate.isAcceptableOrUnknown(
              data['last_karma_heal_date']!, _lastKarmaHealDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      xp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      streakCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak_count'])!,
      maxStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_streak'])!,
      freezeTokens: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}freeze_tokens'])!,
      lastDepositDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_deposit_date']),
      skillPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}skill_points'])!,
      playerClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_class']),
      currentTheme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_theme'])!,
      avatarConfig: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_config']),
      penaltyBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}penalty_balance'])!,
      hackerXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hacker_xp'])!,
      magnateXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}magnate_xp'])!,
      resilienceXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resilience_xp'])!,
      lastBonusClaimDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_bonus_claim_date']),
      bonusStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus_streak'])!,
      crystalsBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}crystals_balance'])!,
      noSpendStreakCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}no_spend_streak_count'])!,
      lastNoSpendDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_no_spend_date']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      karmaDebt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}karma_debt'])!,
      debuffActiveUntil: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}debuff_active_until']),
      partnerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}partner_name']),
      partnerLastDepositDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}partner_last_deposit_date']),
      lastDiversificationXPDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_diversification_x_p_date']),
      lastRebalanceXPDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_rebalance_x_p_date']),
      lastPricePulseXPDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_price_pulse_x_p_date']),
      pricePulseTrackingCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}price_pulse_tracking_count'])!,
      karmaHealingStreakCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}karma_healing_streak_count'])!,
      lastKarmaHealDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_karma_heal_date']),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final int xp;
  final int level;
  final int streakCount;
  final int maxStreak;
  final int freezeTokens;
  final DateTime? lastDepositDate;
  final int skillPoints;
  final String? playerClass;
  final String currentTheme;
  final String? avatarConfig;
  final int penaltyBalance;
  final int hackerXp;
  final int magnateXp;
  final int resilienceXp;
  final DateTime? lastBonusClaimDate;
  final int bonusStreak;
  final int crystalsBalance;
  final int noSpendStreakCount;
  final DateTime? lastNoSpendDate;
  final DateTime updatedAt;
  final int karmaDebt;
  final DateTime? debuffActiveUntil;
  final String? partnerName;
  final DateTime? partnerLastDepositDate;
  final DateTime? lastDiversificationXPDate;
  final DateTime? lastRebalanceXPDate;

  /// Last date XP was awarded for weekly price tracking (+15 XP / 7 days).
  final DateTime? lastPricePulseXPDate;

  /// Total number of successful price checks (for "Снайпер Цін" badge at 5).
  final int pricePulseTrackingCount;
  final int karmaHealingStreakCount;
  final DateTime? lastKarmaHealDate;
  const UserProfile(
      {required this.id,
      required this.xp,
      required this.level,
      required this.streakCount,
      required this.maxStreak,
      required this.freezeTokens,
      this.lastDepositDate,
      required this.skillPoints,
      this.playerClass,
      required this.currentTheme,
      this.avatarConfig,
      required this.penaltyBalance,
      required this.hackerXp,
      required this.magnateXp,
      required this.resilienceXp,
      this.lastBonusClaimDate,
      required this.bonusStreak,
      required this.crystalsBalance,
      required this.noSpendStreakCount,
      this.lastNoSpendDate,
      required this.updatedAt,
      required this.karmaDebt,
      this.debuffActiveUntil,
      this.partnerName,
      this.partnerLastDepositDate,
      this.lastDiversificationXPDate,
      this.lastRebalanceXPDate,
      this.lastPricePulseXPDate,
      required this.pricePulseTrackingCount,
      required this.karmaHealingStreakCount,
      this.lastKarmaHealDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['xp'] = Variable<int>(xp);
    map['level'] = Variable<int>(level);
    map['streak_count'] = Variable<int>(streakCount);
    map['max_streak'] = Variable<int>(maxStreak);
    map['freeze_tokens'] = Variable<int>(freezeTokens);
    if (!nullToAbsent || lastDepositDate != null) {
      map['last_deposit_date'] = Variable<DateTime>(lastDepositDate);
    }
    map['skill_points'] = Variable<int>(skillPoints);
    if (!nullToAbsent || playerClass != null) {
      map['player_class'] = Variable<String>(playerClass);
    }
    map['current_theme'] = Variable<String>(currentTheme);
    if (!nullToAbsent || avatarConfig != null) {
      map['avatar_config'] = Variable<String>(avatarConfig);
    }
    map['penalty_balance'] = Variable<int>(penaltyBalance);
    map['hacker_xp'] = Variable<int>(hackerXp);
    map['magnate_xp'] = Variable<int>(magnateXp);
    map['resilience_xp'] = Variable<int>(resilienceXp);
    if (!nullToAbsent || lastBonusClaimDate != null) {
      map['last_bonus_claim_date'] = Variable<DateTime>(lastBonusClaimDate);
    }
    map['bonus_streak'] = Variable<int>(bonusStreak);
    map['crystals_balance'] = Variable<int>(crystalsBalance);
    map['no_spend_streak_count'] = Variable<int>(noSpendStreakCount);
    if (!nullToAbsent || lastNoSpendDate != null) {
      map['last_no_spend_date'] = Variable<DateTime>(lastNoSpendDate);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['karma_debt'] = Variable<int>(karmaDebt);
    if (!nullToAbsent || debuffActiveUntil != null) {
      map['debuff_active_until'] = Variable<DateTime>(debuffActiveUntil);
    }
    if (!nullToAbsent || partnerName != null) {
      map['partner_name'] = Variable<String>(partnerName);
    }
    if (!nullToAbsent || partnerLastDepositDate != null) {
      map['partner_last_deposit_date'] =
          Variable<DateTime>(partnerLastDepositDate);
    }
    if (!nullToAbsent || lastDiversificationXPDate != null) {
      map['last_diversification_x_p_date'] =
          Variable<DateTime>(lastDiversificationXPDate);
    }
    if (!nullToAbsent || lastRebalanceXPDate != null) {
      map['last_rebalance_x_p_date'] = Variable<DateTime>(lastRebalanceXPDate);
    }
    if (!nullToAbsent || lastPricePulseXPDate != null) {
      map['last_price_pulse_x_p_date'] =
          Variable<DateTime>(lastPricePulseXPDate);
    }
    map['price_pulse_tracking_count'] = Variable<int>(pricePulseTrackingCount);
    map['karma_healing_streak_count'] = Variable<int>(karmaHealingStreakCount);
    if (!nullToAbsent || lastKarmaHealDate != null) {
      map['last_karma_heal_date'] = Variable<DateTime>(lastKarmaHealDate);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      xp: Value(xp),
      level: Value(level),
      streakCount: Value(streakCount),
      maxStreak: Value(maxStreak),
      freezeTokens: Value(freezeTokens),
      lastDepositDate: lastDepositDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDepositDate),
      skillPoints: Value(skillPoints),
      playerClass: playerClass == null && nullToAbsent
          ? const Value.absent()
          : Value(playerClass),
      currentTheme: Value(currentTheme),
      avatarConfig: avatarConfig == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarConfig),
      penaltyBalance: Value(penaltyBalance),
      hackerXp: Value(hackerXp),
      magnateXp: Value(magnateXp),
      resilienceXp: Value(resilienceXp),
      lastBonusClaimDate: lastBonusClaimDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBonusClaimDate),
      bonusStreak: Value(bonusStreak),
      crystalsBalance: Value(crystalsBalance),
      noSpendStreakCount: Value(noSpendStreakCount),
      lastNoSpendDate: lastNoSpendDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNoSpendDate),
      updatedAt: Value(updatedAt),
      karmaDebt: Value(karmaDebt),
      debuffActiveUntil: debuffActiveUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(debuffActiveUntil),
      partnerName: partnerName == null && nullToAbsent
          ? const Value.absent()
          : Value(partnerName),
      partnerLastDepositDate: partnerLastDepositDate == null && nullToAbsent
          ? const Value.absent()
          : Value(partnerLastDepositDate),
      lastDiversificationXPDate:
          lastDiversificationXPDate == null && nullToAbsent
              ? const Value.absent()
              : Value(lastDiversificationXPDate),
      lastRebalanceXPDate: lastRebalanceXPDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRebalanceXPDate),
      lastPricePulseXPDate: lastPricePulseXPDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPricePulseXPDate),
      pricePulseTrackingCount: Value(pricePulseTrackingCount),
      karmaHealingStreakCount: Value(karmaHealingStreakCount),
      lastKarmaHealDate: lastKarmaHealDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastKarmaHealDate),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      xp: serializer.fromJson<int>(json['xp']),
      level: serializer.fromJson<int>(json['level']),
      streakCount: serializer.fromJson<int>(json['streakCount']),
      maxStreak: serializer.fromJson<int>(json['maxStreak']),
      freezeTokens: serializer.fromJson<int>(json['freezeTokens']),
      lastDepositDate: serializer.fromJson<DateTime?>(json['lastDepositDate']),
      skillPoints: serializer.fromJson<int>(json['skillPoints']),
      playerClass: serializer.fromJson<String?>(json['playerClass']),
      currentTheme: serializer.fromJson<String>(json['currentTheme']),
      avatarConfig: serializer.fromJson<String?>(json['avatarConfig']),
      penaltyBalance: serializer.fromJson<int>(json['penaltyBalance']),
      hackerXp: serializer.fromJson<int>(json['hackerXp']),
      magnateXp: serializer.fromJson<int>(json['magnateXp']),
      resilienceXp: serializer.fromJson<int>(json['resilienceXp']),
      lastBonusClaimDate:
          serializer.fromJson<DateTime?>(json['lastBonusClaimDate']),
      bonusStreak: serializer.fromJson<int>(json['bonusStreak']),
      crystalsBalance: serializer.fromJson<int>(json['crystalsBalance']),
      noSpendStreakCount: serializer.fromJson<int>(json['noSpendStreakCount']),
      lastNoSpendDate: serializer.fromJson<DateTime?>(json['lastNoSpendDate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      karmaDebt: serializer.fromJson<int>(json['karmaDebt']),
      debuffActiveUntil:
          serializer.fromJson<DateTime?>(json['debuffActiveUntil']),
      partnerName: serializer.fromJson<String?>(json['partnerName']),
      partnerLastDepositDate:
          serializer.fromJson<DateTime?>(json['partnerLastDepositDate']),
      lastDiversificationXPDate:
          serializer.fromJson<DateTime?>(json['lastDiversificationXPDate']),
      lastRebalanceXPDate:
          serializer.fromJson<DateTime?>(json['lastRebalanceXPDate']),
      lastPricePulseXPDate:
          serializer.fromJson<DateTime?>(json['lastPricePulseXPDate']),
      pricePulseTrackingCount:
          serializer.fromJson<int>(json['pricePulseTrackingCount']),
      karmaHealingStreakCount:
          serializer.fromJson<int>(json['karmaHealingStreakCount']),
      lastKarmaHealDate:
          serializer.fromJson<DateTime?>(json['lastKarmaHealDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'xp': serializer.toJson<int>(xp),
      'level': serializer.toJson<int>(level),
      'streakCount': serializer.toJson<int>(streakCount),
      'maxStreak': serializer.toJson<int>(maxStreak),
      'freezeTokens': serializer.toJson<int>(freezeTokens),
      'lastDepositDate': serializer.toJson<DateTime?>(lastDepositDate),
      'skillPoints': serializer.toJson<int>(skillPoints),
      'playerClass': serializer.toJson<String?>(playerClass),
      'currentTheme': serializer.toJson<String>(currentTheme),
      'avatarConfig': serializer.toJson<String?>(avatarConfig),
      'penaltyBalance': serializer.toJson<int>(penaltyBalance),
      'hackerXp': serializer.toJson<int>(hackerXp),
      'magnateXp': serializer.toJson<int>(magnateXp),
      'resilienceXp': serializer.toJson<int>(resilienceXp),
      'lastBonusClaimDate': serializer.toJson<DateTime?>(lastBonusClaimDate),
      'bonusStreak': serializer.toJson<int>(bonusStreak),
      'crystalsBalance': serializer.toJson<int>(crystalsBalance),
      'noSpendStreakCount': serializer.toJson<int>(noSpendStreakCount),
      'lastNoSpendDate': serializer.toJson<DateTime?>(lastNoSpendDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'karmaDebt': serializer.toJson<int>(karmaDebt),
      'debuffActiveUntil': serializer.toJson<DateTime?>(debuffActiveUntil),
      'partnerName': serializer.toJson<String?>(partnerName),
      'partnerLastDepositDate':
          serializer.toJson<DateTime?>(partnerLastDepositDate),
      'lastDiversificationXPDate':
          serializer.toJson<DateTime?>(lastDiversificationXPDate),
      'lastRebalanceXPDate': serializer.toJson<DateTime?>(lastRebalanceXPDate),
      'lastPricePulseXPDate':
          serializer.toJson<DateTime?>(lastPricePulseXPDate),
      'pricePulseTrackingCount':
          serializer.toJson<int>(pricePulseTrackingCount),
      'karmaHealingStreakCount':
          serializer.toJson<int>(karmaHealingStreakCount),
      'lastKarmaHealDate': serializer.toJson<DateTime?>(lastKarmaHealDate),
    };
  }

  UserProfile copyWith(
          {int? id,
          int? xp,
          int? level,
          int? streakCount,
          int? maxStreak,
          int? freezeTokens,
          Value<DateTime?> lastDepositDate = const Value.absent(),
          int? skillPoints,
          Value<String?> playerClass = const Value.absent(),
          String? currentTheme,
          Value<String?> avatarConfig = const Value.absent(),
          int? penaltyBalance,
          int? hackerXp,
          int? magnateXp,
          int? resilienceXp,
          Value<DateTime?> lastBonusClaimDate = const Value.absent(),
          int? bonusStreak,
          int? crystalsBalance,
          int? noSpendStreakCount,
          Value<DateTime?> lastNoSpendDate = const Value.absent(),
          DateTime? updatedAt,
          int? karmaDebt,
          Value<DateTime?> debuffActiveUntil = const Value.absent(),
          Value<String?> partnerName = const Value.absent(),
          Value<DateTime?> partnerLastDepositDate = const Value.absent(),
          Value<DateTime?> lastDiversificationXPDate = const Value.absent(),
          Value<DateTime?> lastRebalanceXPDate = const Value.absent(),
          Value<DateTime?> lastPricePulseXPDate = const Value.absent(),
          int? pricePulseTrackingCount,
          int? karmaHealingStreakCount,
          Value<DateTime?> lastKarmaHealDate = const Value.absent()}) =>
      UserProfile(
        id: id ?? this.id,
        xp: xp ?? this.xp,
        level: level ?? this.level,
        streakCount: streakCount ?? this.streakCount,
        maxStreak: maxStreak ?? this.maxStreak,
        freezeTokens: freezeTokens ?? this.freezeTokens,
        lastDepositDate: lastDepositDate.present
            ? lastDepositDate.value
            : this.lastDepositDate,
        skillPoints: skillPoints ?? this.skillPoints,
        playerClass: playerClass.present ? playerClass.value : this.playerClass,
        currentTheme: currentTheme ?? this.currentTheme,
        avatarConfig:
            avatarConfig.present ? avatarConfig.value : this.avatarConfig,
        penaltyBalance: penaltyBalance ?? this.penaltyBalance,
        hackerXp: hackerXp ?? this.hackerXp,
        magnateXp: magnateXp ?? this.magnateXp,
        resilienceXp: resilienceXp ?? this.resilienceXp,
        lastBonusClaimDate: lastBonusClaimDate.present
            ? lastBonusClaimDate.value
            : this.lastBonusClaimDate,
        bonusStreak: bonusStreak ?? this.bonusStreak,
        crystalsBalance: crystalsBalance ?? this.crystalsBalance,
        noSpendStreakCount: noSpendStreakCount ?? this.noSpendStreakCount,
        lastNoSpendDate: lastNoSpendDate.present
            ? lastNoSpendDate.value
            : this.lastNoSpendDate,
        updatedAt: updatedAt ?? this.updatedAt,
        karmaDebt: karmaDebt ?? this.karmaDebt,
        debuffActiveUntil: debuffActiveUntil.present
            ? debuffActiveUntil.value
            : this.debuffActiveUntil,
        partnerName: partnerName.present ? partnerName.value : this.partnerName,
        partnerLastDepositDate: partnerLastDepositDate.present
            ? partnerLastDepositDate.value
            : this.partnerLastDepositDate,
        lastDiversificationXPDate: lastDiversificationXPDate.present
            ? lastDiversificationXPDate.value
            : this.lastDiversificationXPDate,
        lastRebalanceXPDate: lastRebalanceXPDate.present
            ? lastRebalanceXPDate.value
            : this.lastRebalanceXPDate,
        lastPricePulseXPDate: lastPricePulseXPDate.present
            ? lastPricePulseXPDate.value
            : this.lastPricePulseXPDate,
        pricePulseTrackingCount:
            pricePulseTrackingCount ?? this.pricePulseTrackingCount,
        karmaHealingStreakCount:
            karmaHealingStreakCount ?? this.karmaHealingStreakCount,
        lastKarmaHealDate: lastKarmaHealDate.present
            ? lastKarmaHealDate.value
            : this.lastKarmaHealDate,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      xp: data.xp.present ? data.xp.value : this.xp,
      level: data.level.present ? data.level.value : this.level,
      streakCount:
          data.streakCount.present ? data.streakCount.value : this.streakCount,
      maxStreak: data.maxStreak.present ? data.maxStreak.value : this.maxStreak,
      freezeTokens: data.freezeTokens.present
          ? data.freezeTokens.value
          : this.freezeTokens,
      lastDepositDate: data.lastDepositDate.present
          ? data.lastDepositDate.value
          : this.lastDepositDate,
      skillPoints:
          data.skillPoints.present ? data.skillPoints.value : this.skillPoints,
      playerClass:
          data.playerClass.present ? data.playerClass.value : this.playerClass,
      currentTheme: data.currentTheme.present
          ? data.currentTheme.value
          : this.currentTheme,
      avatarConfig: data.avatarConfig.present
          ? data.avatarConfig.value
          : this.avatarConfig,
      penaltyBalance: data.penaltyBalance.present
          ? data.penaltyBalance.value
          : this.penaltyBalance,
      hackerXp: data.hackerXp.present ? data.hackerXp.value : this.hackerXp,
      magnateXp: data.magnateXp.present ? data.magnateXp.value : this.magnateXp,
      resilienceXp: data.resilienceXp.present
          ? data.resilienceXp.value
          : this.resilienceXp,
      lastBonusClaimDate: data.lastBonusClaimDate.present
          ? data.lastBonusClaimDate.value
          : this.lastBonusClaimDate,
      bonusStreak:
          data.bonusStreak.present ? data.bonusStreak.value : this.bonusStreak,
      crystalsBalance: data.crystalsBalance.present
          ? data.crystalsBalance.value
          : this.crystalsBalance,
      noSpendStreakCount: data.noSpendStreakCount.present
          ? data.noSpendStreakCount.value
          : this.noSpendStreakCount,
      lastNoSpendDate: data.lastNoSpendDate.present
          ? data.lastNoSpendDate.value
          : this.lastNoSpendDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      karmaDebt: data.karmaDebt.present ? data.karmaDebt.value : this.karmaDebt,
      debuffActiveUntil: data.debuffActiveUntil.present
          ? data.debuffActiveUntil.value
          : this.debuffActiveUntil,
      partnerName:
          data.partnerName.present ? data.partnerName.value : this.partnerName,
      partnerLastDepositDate: data.partnerLastDepositDate.present
          ? data.partnerLastDepositDate.value
          : this.partnerLastDepositDate,
      lastDiversificationXPDate: data.lastDiversificationXPDate.present
          ? data.lastDiversificationXPDate.value
          : this.lastDiversificationXPDate,
      lastRebalanceXPDate: data.lastRebalanceXPDate.present
          ? data.lastRebalanceXPDate.value
          : this.lastRebalanceXPDate,
      lastPricePulseXPDate: data.lastPricePulseXPDate.present
          ? data.lastPricePulseXPDate.value
          : this.lastPricePulseXPDate,
      pricePulseTrackingCount: data.pricePulseTrackingCount.present
          ? data.pricePulseTrackingCount.value
          : this.pricePulseTrackingCount,
      karmaHealingStreakCount: data.karmaHealingStreakCount.present
          ? data.karmaHealingStreakCount.value
          : this.karmaHealingStreakCount,
      lastKarmaHealDate: data.lastKarmaHealDate.present
          ? data.lastKarmaHealDate.value
          : this.lastKarmaHealDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('streakCount: $streakCount, ')
          ..write('maxStreak: $maxStreak, ')
          ..write('freezeTokens: $freezeTokens, ')
          ..write('lastDepositDate: $lastDepositDate, ')
          ..write('skillPoints: $skillPoints, ')
          ..write('playerClass: $playerClass, ')
          ..write('currentTheme: $currentTheme, ')
          ..write('avatarConfig: $avatarConfig, ')
          ..write('penaltyBalance: $penaltyBalance, ')
          ..write('hackerXp: $hackerXp, ')
          ..write('magnateXp: $magnateXp, ')
          ..write('resilienceXp: $resilienceXp, ')
          ..write('lastBonusClaimDate: $lastBonusClaimDate, ')
          ..write('bonusStreak: $bonusStreak, ')
          ..write('crystalsBalance: $crystalsBalance, ')
          ..write('noSpendStreakCount: $noSpendStreakCount, ')
          ..write('lastNoSpendDate: $lastNoSpendDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('karmaDebt: $karmaDebt, ')
          ..write('debuffActiveUntil: $debuffActiveUntil, ')
          ..write('partnerName: $partnerName, ')
          ..write('partnerLastDepositDate: $partnerLastDepositDate, ')
          ..write('lastDiversificationXPDate: $lastDiversificationXPDate, ')
          ..write('lastRebalanceXPDate: $lastRebalanceXPDate, ')
          ..write('lastPricePulseXPDate: $lastPricePulseXPDate, ')
          ..write('pricePulseTrackingCount: $pricePulseTrackingCount, ')
          ..write('karmaHealingStreakCount: $karmaHealingStreakCount, ')
          ..write('lastKarmaHealDate: $lastKarmaHealDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        xp,
        level,
        streakCount,
        maxStreak,
        freezeTokens,
        lastDepositDate,
        skillPoints,
        playerClass,
        currentTheme,
        avatarConfig,
        penaltyBalance,
        hackerXp,
        magnateXp,
        resilienceXp,
        lastBonusClaimDate,
        bonusStreak,
        crystalsBalance,
        noSpendStreakCount,
        lastNoSpendDate,
        updatedAt,
        karmaDebt,
        debuffActiveUntil,
        partnerName,
        partnerLastDepositDate,
        lastDiversificationXPDate,
        lastRebalanceXPDate,
        lastPricePulseXPDate,
        pricePulseTrackingCount,
        karmaHealingStreakCount,
        lastKarmaHealDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.xp == this.xp &&
          other.level == this.level &&
          other.streakCount == this.streakCount &&
          other.maxStreak == this.maxStreak &&
          other.freezeTokens == this.freezeTokens &&
          other.lastDepositDate == this.lastDepositDate &&
          other.skillPoints == this.skillPoints &&
          other.playerClass == this.playerClass &&
          other.currentTheme == this.currentTheme &&
          other.avatarConfig == this.avatarConfig &&
          other.penaltyBalance == this.penaltyBalance &&
          other.hackerXp == this.hackerXp &&
          other.magnateXp == this.magnateXp &&
          other.resilienceXp == this.resilienceXp &&
          other.lastBonusClaimDate == this.lastBonusClaimDate &&
          other.bonusStreak == this.bonusStreak &&
          other.crystalsBalance == this.crystalsBalance &&
          other.noSpendStreakCount == this.noSpendStreakCount &&
          other.lastNoSpendDate == this.lastNoSpendDate &&
          other.updatedAt == this.updatedAt &&
          other.karmaDebt == this.karmaDebt &&
          other.debuffActiveUntil == this.debuffActiveUntil &&
          other.partnerName == this.partnerName &&
          other.partnerLastDepositDate == this.partnerLastDepositDate &&
          other.lastDiversificationXPDate == this.lastDiversificationXPDate &&
          other.lastRebalanceXPDate == this.lastRebalanceXPDate &&
          other.lastPricePulseXPDate == this.lastPricePulseXPDate &&
          other.pricePulseTrackingCount == this.pricePulseTrackingCount &&
          other.karmaHealingStreakCount == this.karmaHealingStreakCount &&
          other.lastKarmaHealDate == this.lastKarmaHealDate);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<int> xp;
  final Value<int> level;
  final Value<int> streakCount;
  final Value<int> maxStreak;
  final Value<int> freezeTokens;
  final Value<DateTime?> lastDepositDate;
  final Value<int> skillPoints;
  final Value<String?> playerClass;
  final Value<String> currentTheme;
  final Value<String?> avatarConfig;
  final Value<int> penaltyBalance;
  final Value<int> hackerXp;
  final Value<int> magnateXp;
  final Value<int> resilienceXp;
  final Value<DateTime?> lastBonusClaimDate;
  final Value<int> bonusStreak;
  final Value<int> crystalsBalance;
  final Value<int> noSpendStreakCount;
  final Value<DateTime?> lastNoSpendDate;
  final Value<DateTime> updatedAt;
  final Value<int> karmaDebt;
  final Value<DateTime?> debuffActiveUntil;
  final Value<String?> partnerName;
  final Value<DateTime?> partnerLastDepositDate;
  final Value<DateTime?> lastDiversificationXPDate;
  final Value<DateTime?> lastRebalanceXPDate;
  final Value<DateTime?> lastPricePulseXPDate;
  final Value<int> pricePulseTrackingCount;
  final Value<int> karmaHealingStreakCount;
  final Value<DateTime?> lastKarmaHealDate;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.streakCount = const Value.absent(),
    this.maxStreak = const Value.absent(),
    this.freezeTokens = const Value.absent(),
    this.lastDepositDate = const Value.absent(),
    this.skillPoints = const Value.absent(),
    this.playerClass = const Value.absent(),
    this.currentTheme = const Value.absent(),
    this.avatarConfig = const Value.absent(),
    this.penaltyBalance = const Value.absent(),
    this.hackerXp = const Value.absent(),
    this.magnateXp = const Value.absent(),
    this.resilienceXp = const Value.absent(),
    this.lastBonusClaimDate = const Value.absent(),
    this.bonusStreak = const Value.absent(),
    this.crystalsBalance = const Value.absent(),
    this.noSpendStreakCount = const Value.absent(),
    this.lastNoSpendDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.karmaDebt = const Value.absent(),
    this.debuffActiveUntil = const Value.absent(),
    this.partnerName = const Value.absent(),
    this.partnerLastDepositDate = const Value.absent(),
    this.lastDiversificationXPDate = const Value.absent(),
    this.lastRebalanceXPDate = const Value.absent(),
    this.lastPricePulseXPDate = const Value.absent(),
    this.pricePulseTrackingCount = const Value.absent(),
    this.karmaHealingStreakCount = const Value.absent(),
    this.lastKarmaHealDate = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.streakCount = const Value.absent(),
    this.maxStreak = const Value.absent(),
    this.freezeTokens = const Value.absent(),
    this.lastDepositDate = const Value.absent(),
    this.skillPoints = const Value.absent(),
    this.playerClass = const Value.absent(),
    this.currentTheme = const Value.absent(),
    this.avatarConfig = const Value.absent(),
    this.penaltyBalance = const Value.absent(),
    this.hackerXp = const Value.absent(),
    this.magnateXp = const Value.absent(),
    this.resilienceXp = const Value.absent(),
    this.lastBonusClaimDate = const Value.absent(),
    this.bonusStreak = const Value.absent(),
    this.crystalsBalance = const Value.absent(),
    this.noSpendStreakCount = const Value.absent(),
    this.lastNoSpendDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.karmaDebt = const Value.absent(),
    this.debuffActiveUntil = const Value.absent(),
    this.partnerName = const Value.absent(),
    this.partnerLastDepositDate = const Value.absent(),
    this.lastDiversificationXPDate = const Value.absent(),
    this.lastRebalanceXPDate = const Value.absent(),
    this.lastPricePulseXPDate = const Value.absent(),
    this.pricePulseTrackingCount = const Value.absent(),
    this.karmaHealingStreakCount = const Value.absent(),
    this.lastKarmaHealDate = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<int>? xp,
    Expression<int>? level,
    Expression<int>? streakCount,
    Expression<int>? maxStreak,
    Expression<int>? freezeTokens,
    Expression<DateTime>? lastDepositDate,
    Expression<int>? skillPoints,
    Expression<String>? playerClass,
    Expression<String>? currentTheme,
    Expression<String>? avatarConfig,
    Expression<int>? penaltyBalance,
    Expression<int>? hackerXp,
    Expression<int>? magnateXp,
    Expression<int>? resilienceXp,
    Expression<DateTime>? lastBonusClaimDate,
    Expression<int>? bonusStreak,
    Expression<int>? crystalsBalance,
    Expression<int>? noSpendStreakCount,
    Expression<DateTime>? lastNoSpendDate,
    Expression<DateTime>? updatedAt,
    Expression<int>? karmaDebt,
    Expression<DateTime>? debuffActiveUntil,
    Expression<String>? partnerName,
    Expression<DateTime>? partnerLastDepositDate,
    Expression<DateTime>? lastDiversificationXPDate,
    Expression<DateTime>? lastRebalanceXPDate,
    Expression<DateTime>? lastPricePulseXPDate,
    Expression<int>? pricePulseTrackingCount,
    Expression<int>? karmaHealingStreakCount,
    Expression<DateTime>? lastKarmaHealDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (xp != null) 'xp': xp,
      if (level != null) 'level': level,
      if (streakCount != null) 'streak_count': streakCount,
      if (maxStreak != null) 'max_streak': maxStreak,
      if (freezeTokens != null) 'freeze_tokens': freezeTokens,
      if (lastDepositDate != null) 'last_deposit_date': lastDepositDate,
      if (skillPoints != null) 'skill_points': skillPoints,
      if (playerClass != null) 'player_class': playerClass,
      if (currentTheme != null) 'current_theme': currentTheme,
      if (avatarConfig != null) 'avatar_config': avatarConfig,
      if (penaltyBalance != null) 'penalty_balance': penaltyBalance,
      if (hackerXp != null) 'hacker_xp': hackerXp,
      if (magnateXp != null) 'magnate_xp': magnateXp,
      if (resilienceXp != null) 'resilience_xp': resilienceXp,
      if (lastBonusClaimDate != null)
        'last_bonus_claim_date': lastBonusClaimDate,
      if (bonusStreak != null) 'bonus_streak': bonusStreak,
      if (crystalsBalance != null) 'crystals_balance': crystalsBalance,
      if (noSpendStreakCount != null)
        'no_spend_streak_count': noSpendStreakCount,
      if (lastNoSpendDate != null) 'last_no_spend_date': lastNoSpendDate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (karmaDebt != null) 'karma_debt': karmaDebt,
      if (debuffActiveUntil != null) 'debuff_active_until': debuffActiveUntil,
      if (partnerName != null) 'partner_name': partnerName,
      if (partnerLastDepositDate != null)
        'partner_last_deposit_date': partnerLastDepositDate,
      if (lastDiversificationXPDate != null)
        'last_diversification_x_p_date': lastDiversificationXPDate,
      if (lastRebalanceXPDate != null)
        'last_rebalance_x_p_date': lastRebalanceXPDate,
      if (lastPricePulseXPDate != null)
        'last_price_pulse_x_p_date': lastPricePulseXPDate,
      if (pricePulseTrackingCount != null)
        'price_pulse_tracking_count': pricePulseTrackingCount,
      if (karmaHealingStreakCount != null)
        'karma_healing_streak_count': karmaHealingStreakCount,
      if (lastKarmaHealDate != null) 'last_karma_heal_date': lastKarmaHealDate,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? id,
      Value<int>? xp,
      Value<int>? level,
      Value<int>? streakCount,
      Value<int>? maxStreak,
      Value<int>? freezeTokens,
      Value<DateTime?>? lastDepositDate,
      Value<int>? skillPoints,
      Value<String?>? playerClass,
      Value<String>? currentTheme,
      Value<String?>? avatarConfig,
      Value<int>? penaltyBalance,
      Value<int>? hackerXp,
      Value<int>? magnateXp,
      Value<int>? resilienceXp,
      Value<DateTime?>? lastBonusClaimDate,
      Value<int>? bonusStreak,
      Value<int>? crystalsBalance,
      Value<int>? noSpendStreakCount,
      Value<DateTime?>? lastNoSpendDate,
      Value<DateTime>? updatedAt,
      Value<int>? karmaDebt,
      Value<DateTime?>? debuffActiveUntil,
      Value<String?>? partnerName,
      Value<DateTime?>? partnerLastDepositDate,
      Value<DateTime?>? lastDiversificationXPDate,
      Value<DateTime?>? lastRebalanceXPDate,
      Value<DateTime?>? lastPricePulseXPDate,
      Value<int>? pricePulseTrackingCount,
      Value<int>? karmaHealingStreakCount,
      Value<DateTime?>? lastKarmaHealDate}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakCount: streakCount ?? this.streakCount,
      maxStreak: maxStreak ?? this.maxStreak,
      freezeTokens: freezeTokens ?? this.freezeTokens,
      lastDepositDate: lastDepositDate ?? this.lastDepositDate,
      skillPoints: skillPoints ?? this.skillPoints,
      playerClass: playerClass ?? this.playerClass,
      currentTheme: currentTheme ?? this.currentTheme,
      avatarConfig: avatarConfig ?? this.avatarConfig,
      penaltyBalance: penaltyBalance ?? this.penaltyBalance,
      hackerXp: hackerXp ?? this.hackerXp,
      magnateXp: magnateXp ?? this.magnateXp,
      resilienceXp: resilienceXp ?? this.resilienceXp,
      lastBonusClaimDate: lastBonusClaimDate ?? this.lastBonusClaimDate,
      bonusStreak: bonusStreak ?? this.bonusStreak,
      crystalsBalance: crystalsBalance ?? this.crystalsBalance,
      noSpendStreakCount: noSpendStreakCount ?? this.noSpendStreakCount,
      lastNoSpendDate: lastNoSpendDate ?? this.lastNoSpendDate,
      updatedAt: updatedAt ?? this.updatedAt,
      karmaDebt: karmaDebt ?? this.karmaDebt,
      debuffActiveUntil: debuffActiveUntil ?? this.debuffActiveUntil,
      partnerName: partnerName ?? this.partnerName,
      partnerLastDepositDate:
          partnerLastDepositDate ?? this.partnerLastDepositDate,
      lastDiversificationXPDate:
          lastDiversificationXPDate ?? this.lastDiversificationXPDate,
      lastRebalanceXPDate: lastRebalanceXPDate ?? this.lastRebalanceXPDate,
      lastPricePulseXPDate: lastPricePulseXPDate ?? this.lastPricePulseXPDate,
      pricePulseTrackingCount:
          pricePulseTrackingCount ?? this.pricePulseTrackingCount,
      karmaHealingStreakCount:
          karmaHealingStreakCount ?? this.karmaHealingStreakCount,
      lastKarmaHealDate: lastKarmaHealDate ?? this.lastKarmaHealDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (streakCount.present) {
      map['streak_count'] = Variable<int>(streakCount.value);
    }
    if (maxStreak.present) {
      map['max_streak'] = Variable<int>(maxStreak.value);
    }
    if (freezeTokens.present) {
      map['freeze_tokens'] = Variable<int>(freezeTokens.value);
    }
    if (lastDepositDate.present) {
      map['last_deposit_date'] = Variable<DateTime>(lastDepositDate.value);
    }
    if (skillPoints.present) {
      map['skill_points'] = Variable<int>(skillPoints.value);
    }
    if (playerClass.present) {
      map['player_class'] = Variable<String>(playerClass.value);
    }
    if (currentTheme.present) {
      map['current_theme'] = Variable<String>(currentTheme.value);
    }
    if (avatarConfig.present) {
      map['avatar_config'] = Variable<String>(avatarConfig.value);
    }
    if (penaltyBalance.present) {
      map['penalty_balance'] = Variable<int>(penaltyBalance.value);
    }
    if (hackerXp.present) {
      map['hacker_xp'] = Variable<int>(hackerXp.value);
    }
    if (magnateXp.present) {
      map['magnate_xp'] = Variable<int>(magnateXp.value);
    }
    if (resilienceXp.present) {
      map['resilience_xp'] = Variable<int>(resilienceXp.value);
    }
    if (lastBonusClaimDate.present) {
      map['last_bonus_claim_date'] =
          Variable<DateTime>(lastBonusClaimDate.value);
    }
    if (bonusStreak.present) {
      map['bonus_streak'] = Variable<int>(bonusStreak.value);
    }
    if (crystalsBalance.present) {
      map['crystals_balance'] = Variable<int>(crystalsBalance.value);
    }
    if (noSpendStreakCount.present) {
      map['no_spend_streak_count'] = Variable<int>(noSpendStreakCount.value);
    }
    if (lastNoSpendDate.present) {
      map['last_no_spend_date'] = Variable<DateTime>(lastNoSpendDate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (karmaDebt.present) {
      map['karma_debt'] = Variable<int>(karmaDebt.value);
    }
    if (debuffActiveUntil.present) {
      map['debuff_active_until'] = Variable<DateTime>(debuffActiveUntil.value);
    }
    if (partnerName.present) {
      map['partner_name'] = Variable<String>(partnerName.value);
    }
    if (partnerLastDepositDate.present) {
      map['partner_last_deposit_date'] =
          Variable<DateTime>(partnerLastDepositDate.value);
    }
    if (lastDiversificationXPDate.present) {
      map['last_diversification_x_p_date'] =
          Variable<DateTime>(lastDiversificationXPDate.value);
    }
    if (lastRebalanceXPDate.present) {
      map['last_rebalance_x_p_date'] =
          Variable<DateTime>(lastRebalanceXPDate.value);
    }
    if (lastPricePulseXPDate.present) {
      map['last_price_pulse_x_p_date'] =
          Variable<DateTime>(lastPricePulseXPDate.value);
    }
    if (pricePulseTrackingCount.present) {
      map['price_pulse_tracking_count'] =
          Variable<int>(pricePulseTrackingCount.value);
    }
    if (karmaHealingStreakCount.present) {
      map['karma_healing_streak_count'] =
          Variable<int>(karmaHealingStreakCount.value);
    }
    if (lastKarmaHealDate.present) {
      map['last_karma_heal_date'] = Variable<DateTime>(lastKarmaHealDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('streakCount: $streakCount, ')
          ..write('maxStreak: $maxStreak, ')
          ..write('freezeTokens: $freezeTokens, ')
          ..write('lastDepositDate: $lastDepositDate, ')
          ..write('skillPoints: $skillPoints, ')
          ..write('playerClass: $playerClass, ')
          ..write('currentTheme: $currentTheme, ')
          ..write('avatarConfig: $avatarConfig, ')
          ..write('penaltyBalance: $penaltyBalance, ')
          ..write('hackerXp: $hackerXp, ')
          ..write('magnateXp: $magnateXp, ')
          ..write('resilienceXp: $resilienceXp, ')
          ..write('lastBonusClaimDate: $lastBonusClaimDate, ')
          ..write('bonusStreak: $bonusStreak, ')
          ..write('crystalsBalance: $crystalsBalance, ')
          ..write('noSpendStreakCount: $noSpendStreakCount, ')
          ..write('lastNoSpendDate: $lastNoSpendDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('karmaDebt: $karmaDebt, ')
          ..write('debuffActiveUntil: $debuffActiveUntil, ')
          ..write('partnerName: $partnerName, ')
          ..write('partnerLastDepositDate: $partnerLastDepositDate, ')
          ..write('lastDiversificationXPDate: $lastDiversificationXPDate, ')
          ..write('lastRebalanceXPDate: $lastRebalanceXPDate, ')
          ..write('lastPricePulseXPDate: $lastPricePulseXPDate, ')
          ..write('pricePulseTrackingCount: $pricePulseTrackingCount, ')
          ..write('karmaHealingStreakCount: $karmaHealingStreakCount, ')
          ..write('lastKarmaHealDate: $lastKarmaHealDate')
          ..write(')'))
        .toString();
  }
}

class $UnlockedAchievementsTable extends UnlockedAchievements
    with TableInfo<$UnlockedAchievementsTable, UnlockedAchievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_achievements';
  @override
  VerificationContext validateIntegrity(
      Insertable<UnlockedAchievement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnlockedAchievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedAchievement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $UnlockedAchievementsTable createAlias(String alias) {
    return $UnlockedAchievementsTable(attachedDatabase, alias);
  }
}

class UnlockedAchievement extends DataClass
    implements Insertable<UnlockedAchievement> {
  final String id;
  final DateTime unlockedAt;
  const UnlockedAchievement({required this.id, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UnlockedAchievementsCompanion toCompanion(bool nullToAbsent) {
    return UnlockedAchievementsCompanion(
      id: Value(id),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UnlockedAchievement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedAchievement(
      id: serializer.fromJson<String>(json['id']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UnlockedAchievement copyWith({String? id, DateTime? unlockedAt}) =>
      UnlockedAchievement(
        id: id ?? this.id,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  UnlockedAchievement copyWithCompanion(UnlockedAchievementsCompanion data) {
    return UnlockedAchievement(
      id: data.id.present ? data.id.value : this.id,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedAchievement(')
          ..write('id: $id, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedAchievement &&
          other.id == this.id &&
          other.unlockedAt == this.unlockedAt);
}

class UnlockedAchievementsCompanion
    extends UpdateCompanion<UnlockedAchievement> {
  final Value<String> id;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const UnlockedAchievementsCompanion({
    this.id = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockedAchievementsCompanion.insert({
    required String id,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        unlockedAt = Value(unlockedAt);
  static Insertable<UnlockedAchievement> custom({
    Expression<String>? id,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockedAchievementsCompanion copyWith(
      {Value<String>? id, Value<DateTime>? unlockedAt, Value<int>? rowid}) {
    return UnlockedAchievementsCompanion(
      id: id ?? this.id,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedAchievementsCompanion(')
          ..write('id: $id, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnlockedSkillsTable extends UnlockedSkills
    with TableInfo<$UnlockedSkillsTable, UnlockedSkill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedSkillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_skills';
  @override
  VerificationContext validateIntegrity(Insertable<UnlockedSkill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnlockedSkill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedSkill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $UnlockedSkillsTable createAlias(String alias) {
    return $UnlockedSkillsTable(attachedDatabase, alias);
  }
}

class UnlockedSkill extends DataClass implements Insertable<UnlockedSkill> {
  final String id;
  final DateTime unlockedAt;
  const UnlockedSkill({required this.id, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UnlockedSkillsCompanion toCompanion(bool nullToAbsent) {
    return UnlockedSkillsCompanion(
      id: Value(id),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UnlockedSkill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedSkill(
      id: serializer.fromJson<String>(json['id']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UnlockedSkill copyWith({String? id, DateTime? unlockedAt}) => UnlockedSkill(
        id: id ?? this.id,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  UnlockedSkill copyWithCompanion(UnlockedSkillsCompanion data) {
    return UnlockedSkill(
      id: data.id.present ? data.id.value : this.id,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedSkill(')
          ..write('id: $id, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedSkill &&
          other.id == this.id &&
          other.unlockedAt == this.unlockedAt);
}

class UnlockedSkillsCompanion extends UpdateCompanion<UnlockedSkill> {
  final Value<String> id;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const UnlockedSkillsCompanion({
    this.id = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockedSkillsCompanion.insert({
    required String id,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        unlockedAt = Value(unlockedAt);
  static Insertable<UnlockedSkill> custom({
    Expression<String>? id,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockedSkillsCompanion copyWith(
      {Value<String>? id, Value<DateTime>? unlockedAt, Value<int>? rowid}) {
    return UnlockedSkillsCompanion(
      id: id ?? this.id,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedSkillsCompanion(')
          ..write('id: $id, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LootboxesTable extends Lootboxes
    with TableInfo<$LootboxesTable, Lootboxe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LootboxesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
      'rarity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isOpenedMeta =
      const VerificationMeta('isOpened');
  @override
  late final GeneratedColumn<bool> isOpened = GeneratedColumn<bool>(
      'is_opened', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_opened" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _earnedAtMeta =
      const VerificationMeta('earnedAt');
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
      'earned_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, rarity, isOpened, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lootboxes';
  @override
  VerificationContext validateIntegrity(Insertable<Lootboxe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('is_opened')) {
      context.handle(_isOpenedMeta,
          isOpened.isAcceptableOrUnknown(data['is_opened']!, _isOpenedMeta));
    }
    if (data.containsKey('earned_at')) {
      context.handle(_earnedAtMeta,
          earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta));
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lootboxe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lootboxe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity'])!,
      isOpened: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_opened'])!,
      earnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}earned_at'])!,
    );
  }

  @override
  $LootboxesTable createAlias(String alias) {
    return $LootboxesTable(attachedDatabase, alias);
  }
}

class Lootboxe extends DataClass implements Insertable<Lootboxe> {
  final String id;
  final String rarity;
  final bool isOpened;
  final DateTime earnedAt;
  const Lootboxe(
      {required this.id,
      required this.rarity,
      required this.isOpened,
      required this.earnedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rarity'] = Variable<String>(rarity);
    map['is_opened'] = Variable<bool>(isOpened);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    return map;
  }

  LootboxesCompanion toCompanion(bool nullToAbsent) {
    return LootboxesCompanion(
      id: Value(id),
      rarity: Value(rarity),
      isOpened: Value(isOpened),
      earnedAt: Value(earnedAt),
    );
  }

  factory Lootboxe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lootboxe(
      id: serializer.fromJson<String>(json['id']),
      rarity: serializer.fromJson<String>(json['rarity']),
      isOpened: serializer.fromJson<bool>(json['isOpened']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rarity': serializer.toJson<String>(rarity),
      'isOpened': serializer.toJson<bool>(isOpened),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
    };
  }

  Lootboxe copyWith(
          {String? id, String? rarity, bool? isOpened, DateTime? earnedAt}) =>
      Lootboxe(
        id: id ?? this.id,
        rarity: rarity ?? this.rarity,
        isOpened: isOpened ?? this.isOpened,
        earnedAt: earnedAt ?? this.earnedAt,
      );
  Lootboxe copyWithCompanion(LootboxesCompanion data) {
    return Lootboxe(
      id: data.id.present ? data.id.value : this.id,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      isOpened: data.isOpened.present ? data.isOpened.value : this.isOpened,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lootboxe(')
          ..write('id: $id, ')
          ..write('rarity: $rarity, ')
          ..write('isOpened: $isOpened, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rarity, isOpened, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lootboxe &&
          other.id == this.id &&
          other.rarity == this.rarity &&
          other.isOpened == this.isOpened &&
          other.earnedAt == this.earnedAt);
}

class LootboxesCompanion extends UpdateCompanion<Lootboxe> {
  final Value<String> id;
  final Value<String> rarity;
  final Value<bool> isOpened;
  final Value<DateTime> earnedAt;
  final Value<int> rowid;
  const LootboxesCompanion({
    this.id = const Value.absent(),
    this.rarity = const Value.absent(),
    this.isOpened = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LootboxesCompanion.insert({
    required String id,
    required String rarity,
    this.isOpened = const Value.absent(),
    required DateTime earnedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        rarity = Value(rarity),
        earnedAt = Value(earnedAt);
  static Insertable<Lootboxe> custom({
    Expression<String>? id,
    Expression<String>? rarity,
    Expression<bool>? isOpened,
    Expression<DateTime>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rarity != null) 'rarity': rarity,
      if (isOpened != null) 'is_opened': isOpened,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LootboxesCompanion copyWith(
      {Value<String>? id,
      Value<String>? rarity,
      Value<bool>? isOpened,
      Value<DateTime>? earnedAt,
      Value<int>? rowid}) {
    return LootboxesCompanion(
      id: id ?? this.id,
      rarity: rarity ?? this.rarity,
      isOpened: isOpened ?? this.isOpened,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (isOpened.present) {
      map['is_opened'] = Variable<bool>(isOpened.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LootboxesCompanion(')
          ..write('id: $id, ')
          ..write('rarity: $rarity, ')
          ..write('isOpened: $isOpened, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PetsTable extends Pets with TableInfo<$PetsTable, Pet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _petTypeMeta =
      const VerificationMeta('petType');
  @override
  late final GeneratedColumn<String> petType = GeneratedColumn<String>(
      'pet_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _happinessLevelMeta =
      const VerificationMeta('happinessLevel');
  @override
  late final GeneratedColumn<int> happinessLevel = GeneratedColumn<int>(
      'happiness_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _lastFedAtMeta =
      const VerificationMeta('lastFedAt');
  @override
  late final GeneratedColumn<DateTime> lastFedAt = GeneratedColumn<DateTime>(
      'last_fed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, petType, happinessLevel, lastFedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pets';
  @override
  VerificationContext validateIntegrity(Insertable<Pet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pet_type')) {
      context.handle(_petTypeMeta,
          petType.isAcceptableOrUnknown(data['pet_type']!, _petTypeMeta));
    } else if (isInserting) {
      context.missing(_petTypeMeta);
    }
    if (data.containsKey('happiness_level')) {
      context.handle(
          _happinessLevelMeta,
          happinessLevel.isAcceptableOrUnknown(
              data['happiness_level']!, _happinessLevelMeta));
    }
    if (data.containsKey('last_fed_at')) {
      context.handle(
          _lastFedAtMeta,
          lastFedAt.isAcceptableOrUnknown(
              data['last_fed_at']!, _lastFedAtMeta));
    } else if (isInserting) {
      context.missing(_lastFedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      petType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pet_type'])!,
      happinessLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}happiness_level'])!,
      lastFedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_fed_at'])!,
    );
  }

  @override
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }
}

class Pet extends DataClass implements Insertable<Pet> {
  final String id;
  final String petType;
  final int happinessLevel;
  final DateTime lastFedAt;
  const Pet(
      {required this.id,
      required this.petType,
      required this.happinessLevel,
      required this.lastFedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pet_type'] = Variable<String>(petType);
    map['happiness_level'] = Variable<int>(happinessLevel);
    map['last_fed_at'] = Variable<DateTime>(lastFedAt);
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      petType: Value(petType),
      happinessLevel: Value(happinessLevel),
      lastFedAt: Value(lastFedAt),
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pet(
      id: serializer.fromJson<String>(json['id']),
      petType: serializer.fromJson<String>(json['petType']),
      happinessLevel: serializer.fromJson<int>(json['happinessLevel']),
      lastFedAt: serializer.fromJson<DateTime>(json['lastFedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'petType': serializer.toJson<String>(petType),
      'happinessLevel': serializer.toJson<int>(happinessLevel),
      'lastFedAt': serializer.toJson<DateTime>(lastFedAt),
    };
  }

  Pet copyWith(
          {String? id,
          String? petType,
          int? happinessLevel,
          DateTime? lastFedAt}) =>
      Pet(
        id: id ?? this.id,
        petType: petType ?? this.petType,
        happinessLevel: happinessLevel ?? this.happinessLevel,
        lastFedAt: lastFedAt ?? this.lastFedAt,
      );
  Pet copyWithCompanion(PetsCompanion data) {
    return Pet(
      id: data.id.present ? data.id.value : this.id,
      petType: data.petType.present ? data.petType.value : this.petType,
      happinessLevel: data.happinessLevel.present
          ? data.happinessLevel.value
          : this.happinessLevel,
      lastFedAt: data.lastFedAt.present ? data.lastFedAt.value : this.lastFedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pet(')
          ..write('id: $id, ')
          ..write('petType: $petType, ')
          ..write('happinessLevel: $happinessLevel, ')
          ..write('lastFedAt: $lastFedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, petType, happinessLevel, lastFedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          other.id == this.id &&
          other.petType == this.petType &&
          other.happinessLevel == this.happinessLevel &&
          other.lastFedAt == this.lastFedAt);
}

class PetsCompanion extends UpdateCompanion<Pet> {
  final Value<String> id;
  final Value<String> petType;
  final Value<int> happinessLevel;
  final Value<DateTime> lastFedAt;
  final Value<int> rowid;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.petType = const Value.absent(),
    this.happinessLevel = const Value.absent(),
    this.lastFedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetsCompanion.insert({
    required String id,
    required String petType,
    this.happinessLevel = const Value.absent(),
    required DateTime lastFedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        petType = Value(petType),
        lastFedAt = Value(lastFedAt);
  static Insertable<Pet> custom({
    Expression<String>? id,
    Expression<String>? petType,
    Expression<int>? happinessLevel,
    Expression<DateTime>? lastFedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petType != null) 'pet_type': petType,
      if (happinessLevel != null) 'happiness_level': happinessLevel,
      if (lastFedAt != null) 'last_fed_at': lastFedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? petType,
      Value<int>? happinessLevel,
      Value<DateTime>? lastFedAt,
      Value<int>? rowid}) {
    return PetsCompanion(
      id: id ?? this.id,
      petType: petType ?? this.petType,
      happinessLevel: happinessLevel ?? this.happinessLevel,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (petType.present) {
      map['pet_type'] = Variable<String>(petType.value);
    }
    if (happinessLevel.present) {
      map['happiness_level'] = Variable<int>(happinessLevel.value);
    }
    if (lastFedAt.present) {
      map['last_fed_at'] = Variable<DateTime>(lastFedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetsCompanion(')
          ..write('id: $id, ')
          ..write('petType: $petType, ')
          ..write('happinessLevel: $happinessLevel, ')
          ..write('lastFedAt: $lastFedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SquadsTable extends Squads with TableInfo<$SquadsTable, Squad> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SquadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalXpMeta =
      const VerificationMeta('totalXp');
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
      'total_xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, totalXp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'squads';
  @override
  VerificationContext validateIntegrity(Insertable<Squad> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('total_xp')) {
      context.handle(_totalXpMeta,
          totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Squad map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Squad(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      totalXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_xp'])!,
    );
  }

  @override
  $SquadsTable createAlias(String alias) {
    return $SquadsTable(attachedDatabase, alias);
  }
}

class Squad extends DataClass implements Insertable<Squad> {
  final String id;
  final String name;
  final int totalXp;
  const Squad({required this.id, required this.name, required this.totalXp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['total_xp'] = Variable<int>(totalXp);
    return map;
  }

  SquadsCompanion toCompanion(bool nullToAbsent) {
    return SquadsCompanion(
      id: Value(id),
      name: Value(name),
      totalXp: Value(totalXp),
    );
  }

  factory Squad.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Squad(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'totalXp': serializer.toJson<int>(totalXp),
    };
  }

  Squad copyWith({String? id, String? name, int? totalXp}) => Squad(
        id: id ?? this.id,
        name: name ?? this.name,
        totalXp: totalXp ?? this.totalXp,
      );
  Squad copyWithCompanion(SquadsCompanion data) {
    return Squad(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Squad(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('totalXp: $totalXp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, totalXp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Squad &&
          other.id == this.id &&
          other.name == this.name &&
          other.totalXp == this.totalXp);
}

class SquadsCompanion extends UpdateCompanion<Squad> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> totalXp;
  final Value<int> rowid;
  const SquadsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SquadsCompanion.insert({
    required String id,
    required String name,
    this.totalXp = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Squad> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? totalXp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (totalXp != null) 'total_xp': totalXp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SquadsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? totalXp,
      Value<int>? rowid}) {
    return SquadsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      totalXp: totalXp ?? this.totalXp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SquadsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('totalXp: $totalXp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SideQuestsTable extends SideQuests
    with TableInfo<$SideQuestsTable, SideQuest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SideQuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, isCompleted, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'side_quests';
  @override
  VerificationContext validateIntegrity(Insertable<SideQuest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SideQuest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SideQuest(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
    );
  }

  @override
  $SideQuestsTable createAlias(String alias) {
    return $SideQuestsTable(attachedDatabase, alias);
  }
}

class SideQuest extends DataClass implements Insertable<SideQuest> {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime expiresAt;
  const SideQuest(
      {required this.id,
      required this.title,
      required this.description,
      required this.isCompleted,
      required this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  SideQuestsCompanion toCompanion(bool nullToAbsent) {
    return SideQuestsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      isCompleted: Value(isCompleted),
      expiresAt: Value(expiresAt),
    );
  }

  factory SideQuest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SideQuest(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  SideQuest copyWith(
          {String? id,
          String? title,
          String? description,
          bool? isCompleted,
          DateTime? expiresAt}) =>
      SideQuest(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        expiresAt: expiresAt ?? this.expiresAt,
      );
  SideQuest copyWithCompanion(SideQuestsCompanion data) {
    return SideQuest(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SideQuest(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, isCompleted, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SideQuest &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.expiresAt == this.expiresAt);
}

class SideQuestsCompanion extends UpdateCompanion<SideQuest> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<bool> isCompleted;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const SideQuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SideQuestsCompanion.insert({
    required String id,
    required String title,
    required String description,
    this.isCompleted = const Value.absent(),
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        description = Value(description),
        expiresAt = Value(expiresAt);
  static Insertable<SideQuest> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SideQuestsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<bool>? isCompleted,
      Value<DateTime>? expiresAt,
      Value<int>? rowid}) {
    return SideQuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SideQuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionTagsTable extends TransactionTags
    with TableInfo<$TransactionTagsTable, TransactionTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depositIdMeta =
      const VerificationMeta('depositId');
  @override
  late final GeneratedColumn<String> depositId = GeneratedColumn<String>(
      'deposit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
      'tag', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, depositId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_tags';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deposit_id')) {
      context.handle(_depositIdMeta,
          depositId.isAcceptableOrUnknown(data['deposit_id']!, _depositIdMeta));
    } else if (isInserting) {
      context.missing(_depositIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      depositId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deposit_id'])!,
      tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag'])!,
    );
  }

  @override
  $TransactionTagsTable createAlias(String alias) {
    return $TransactionTagsTable(attachedDatabase, alias);
  }
}

class TransactionTag extends DataClass implements Insertable<TransactionTag> {
  final String id;
  final String depositId;
  final String tag;
  const TransactionTag(
      {required this.id, required this.depositId, required this.tag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deposit_id'] = Variable<String>(depositId);
    map['tag'] = Variable<String>(tag);
    return map;
  }

  TransactionTagsCompanion toCompanion(bool nullToAbsent) {
    return TransactionTagsCompanion(
      id: Value(id),
      depositId: Value(depositId),
      tag: Value(tag),
    );
  }

  factory TransactionTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTag(
      id: serializer.fromJson<String>(json['id']),
      depositId: serializer.fromJson<String>(json['depositId']),
      tag: serializer.fromJson<String>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'depositId': serializer.toJson<String>(depositId),
      'tag': serializer.toJson<String>(tag),
    };
  }

  TransactionTag copyWith({String? id, String? depositId, String? tag}) =>
      TransactionTag(
        id: id ?? this.id,
        depositId: depositId ?? this.depositId,
        tag: tag ?? this.tag,
      );
  TransactionTag copyWithCompanion(TransactionTagsCompanion data) {
    return TransactionTag(
      id: data.id.present ? data.id.value : this.id,
      depositId: data.depositId.present ? data.depositId.value : this.depositId,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTag(')
          ..write('id: $id, ')
          ..write('depositId: $depositId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, depositId, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTag &&
          other.id == this.id &&
          other.depositId == this.depositId &&
          other.tag == this.tag);
}

class TransactionTagsCompanion extends UpdateCompanion<TransactionTag> {
  final Value<String> id;
  final Value<String> depositId;
  final Value<String> tag;
  final Value<int> rowid;
  const TransactionTagsCompanion({
    this.id = const Value.absent(),
    this.depositId = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionTagsCompanion.insert({
    required String id,
    required String depositId,
    required String tag,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        depositId = Value(depositId),
        tag = Value(tag);
  static Insertable<TransactionTag> custom({
    Expression<String>? id,
    Expression<String>? depositId,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (depositId != null) 'deposit_id': depositId,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionTagsCompanion copyWith(
      {Value<String>? id,
      Value<String>? depositId,
      Value<String>? tag,
      Value<int>? rowid}) {
    return TransactionTagsCompanion(
      id: id ?? this.id,
      depositId: depositId ?? this.depositId,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (depositId.present) {
      map['deposit_id'] = Variable<String>(depositId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTagsCompanion(')
          ..write('id: $id, ')
          ..write('depositId: $depositId, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoiceLogsTable extends VoiceLogs
    with TableInfo<$VoiceLogsTable, VoiceLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoiceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depositIdMeta =
      const VerificationMeta('depositId');
  @override
  late final GeneratedColumn<String> depositId = GeneratedColumn<String>(
      'deposit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, depositId, filePath, recordedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voice_logs';
  @override
  VerificationContext validateIntegrity(Insertable<VoiceLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deposit_id')) {
      context.handle(_depositIdMeta,
          depositId.isAcceptableOrUnknown(data['deposit_id']!, _depositIdMeta));
    } else if (isInserting) {
      context.missing(_depositIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VoiceLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoiceLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      depositId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deposit_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
    );
  }

  @override
  $VoiceLogsTable createAlias(String alias) {
    return $VoiceLogsTable(attachedDatabase, alias);
  }
}

class VoiceLog extends DataClass implements Insertable<VoiceLog> {
  final String id;
  final String depositId;
  final String filePath;
  final DateTime recordedAt;
  const VoiceLog(
      {required this.id,
      required this.depositId,
      required this.filePath,
      required this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deposit_id'] = Variable<String>(depositId);
    map['file_path'] = Variable<String>(filePath);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  VoiceLogsCompanion toCompanion(bool nullToAbsent) {
    return VoiceLogsCompanion(
      id: Value(id),
      depositId: Value(depositId),
      filePath: Value(filePath),
      recordedAt: Value(recordedAt),
    );
  }

  factory VoiceLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoiceLog(
      id: serializer.fromJson<String>(json['id']),
      depositId: serializer.fromJson<String>(json['depositId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'depositId': serializer.toJson<String>(depositId),
      'filePath': serializer.toJson<String>(filePath),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  VoiceLog copyWith(
          {String? id,
          String? depositId,
          String? filePath,
          DateTime? recordedAt}) =>
      VoiceLog(
        id: id ?? this.id,
        depositId: depositId ?? this.depositId,
        filePath: filePath ?? this.filePath,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  VoiceLog copyWithCompanion(VoiceLogsCompanion data) {
    return VoiceLog(
      id: data.id.present ? data.id.value : this.id,
      depositId: data.depositId.present ? data.depositId.value : this.depositId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoiceLog(')
          ..write('id: $id, ')
          ..write('depositId: $depositId, ')
          ..write('filePath: $filePath, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, depositId, filePath, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoiceLog &&
          other.id == this.id &&
          other.depositId == this.depositId &&
          other.filePath == this.filePath &&
          other.recordedAt == this.recordedAt);
}

class VoiceLogsCompanion extends UpdateCompanion<VoiceLog> {
  final Value<String> id;
  final Value<String> depositId;
  final Value<String> filePath;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const VoiceLogsCompanion({
    this.id = const Value.absent(),
    this.depositId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoiceLogsCompanion.insert({
    required String id,
    required String depositId,
    required String filePath,
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        depositId = Value(depositId),
        filePath = Value(filePath),
        recordedAt = Value(recordedAt);
  static Insertable<VoiceLog> custom({
    Expression<String>? id,
    Expression<String>? depositId,
    Expression<String>? filePath,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (depositId != null) 'deposit_id': depositId,
      if (filePath != null) 'file_path': filePath,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoiceLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? depositId,
      Value<String>? filePath,
      Value<DateTime>? recordedAt,
      Value<int>? rowid}) {
    return VoiceLogsCompanion(
      id: id ?? this.id,
      depositId: depositId ?? this.depositId,
      filePath: filePath ?? this.filePath,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (depositId.present) {
      map['deposit_id'] = Variable<String>(depositId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VoiceLogsCompanion(')
          ..write('id: $id, ')
          ..write('depositId: $depositId, ')
          ..write('filePath: $filePath, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PenaltyHabitsTable extends PenaltyHabits
    with TableInfo<$PenaltyHabitsTable, PenaltyHabit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PenaltyHabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitNameMeta =
      const VerificationMeta('habitName');
  @override
  late final GeneratedColumn<String> habitName = GeneratedColumn<String>(
      'habit_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _penaltyAmountMeta =
      const VerificationMeta('penaltyAmount');
  @override
  late final GeneratedColumn<int> penaltyAmount = GeneratedColumn<int>(
      'penalty_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, habitName, penaltyAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'penalty_habits';
  @override
  VerificationContext validateIntegrity(Insertable<PenaltyHabit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_name')) {
      context.handle(_habitNameMeta,
          habitName.isAcceptableOrUnknown(data['habit_name']!, _habitNameMeta));
    } else if (isInserting) {
      context.missing(_habitNameMeta);
    }
    if (data.containsKey('penalty_amount')) {
      context.handle(
          _penaltyAmountMeta,
          penaltyAmount.isAcceptableOrUnknown(
              data['penalty_amount']!, _penaltyAmountMeta));
    } else if (isInserting) {
      context.missing(_penaltyAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PenaltyHabit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PenaltyHabit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_name'])!,
      penaltyAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}penalty_amount'])!,
    );
  }

  @override
  $PenaltyHabitsTable createAlias(String alias) {
    return $PenaltyHabitsTable(attachedDatabase, alias);
  }
}

class PenaltyHabit extends DataClass implements Insertable<PenaltyHabit> {
  final String id;
  final String habitName;
  final int penaltyAmount;
  const PenaltyHabit(
      {required this.id, required this.habitName, required this.penaltyAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_name'] = Variable<String>(habitName);
    map['penalty_amount'] = Variable<int>(penaltyAmount);
    return map;
  }

  PenaltyHabitsCompanion toCompanion(bool nullToAbsent) {
    return PenaltyHabitsCompanion(
      id: Value(id),
      habitName: Value(habitName),
      penaltyAmount: Value(penaltyAmount),
    );
  }

  factory PenaltyHabit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PenaltyHabit(
      id: serializer.fromJson<String>(json['id']),
      habitName: serializer.fromJson<String>(json['habitName']),
      penaltyAmount: serializer.fromJson<int>(json['penaltyAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitName': serializer.toJson<String>(habitName),
      'penaltyAmount': serializer.toJson<int>(penaltyAmount),
    };
  }

  PenaltyHabit copyWith({String? id, String? habitName, int? penaltyAmount}) =>
      PenaltyHabit(
        id: id ?? this.id,
        habitName: habitName ?? this.habitName,
        penaltyAmount: penaltyAmount ?? this.penaltyAmount,
      );
  PenaltyHabit copyWithCompanion(PenaltyHabitsCompanion data) {
    return PenaltyHabit(
      id: data.id.present ? data.id.value : this.id,
      habitName: data.habitName.present ? data.habitName.value : this.habitName,
      penaltyAmount: data.penaltyAmount.present
          ? data.penaltyAmount.value
          : this.penaltyAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PenaltyHabit(')
          ..write('id: $id, ')
          ..write('habitName: $habitName, ')
          ..write('penaltyAmount: $penaltyAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitName, penaltyAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PenaltyHabit &&
          other.id == this.id &&
          other.habitName == this.habitName &&
          other.penaltyAmount == this.penaltyAmount);
}

class PenaltyHabitsCompanion extends UpdateCompanion<PenaltyHabit> {
  final Value<String> id;
  final Value<String> habitName;
  final Value<int> penaltyAmount;
  final Value<int> rowid;
  const PenaltyHabitsCompanion({
    this.id = const Value.absent(),
    this.habitName = const Value.absent(),
    this.penaltyAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PenaltyHabitsCompanion.insert({
    required String id,
    required String habitName,
    required int penaltyAmount,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitName = Value(habitName),
        penaltyAmount = Value(penaltyAmount);
  static Insertable<PenaltyHabit> custom({
    Expression<String>? id,
    Expression<String>? habitName,
    Expression<int>? penaltyAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitName != null) 'habit_name': habitName,
      if (penaltyAmount != null) 'penalty_amount': penaltyAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PenaltyHabitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitName,
      Value<int>? penaltyAmount,
      Value<int>? rowid}) {
    return PenaltyHabitsCompanion(
      id: id ?? this.id,
      habitName: habitName ?? this.habitName,
      penaltyAmount: penaltyAmount ?? this.penaltyAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitName.present) {
      map['habit_name'] = Variable<String>(habitName.value);
    }
    if (penaltyAmount.present) {
      map['penalty_amount'] = Variable<int>(penaltyAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PenaltyHabitsCompanion(')
          ..write('id: $id, ')
          ..write('habitName: $habitName, ')
          ..write('penaltyAmount: $penaltyAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JointGoalsTable extends JointGoals
    with TableInfo<$JointGoalsTable, JointGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JointGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<int> currentAmount = GeneratedColumn<int>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, targetAmount, currentAmount, deadline, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'joint_goals';
  @override
  VerificationContext validateIntegrity(Insertable<JointGoal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JointGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JointGoal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_amount'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JointGoalsTable createAlias(String alias) {
    return $JointGoalsTable(attachedDatabase, alias);
  }
}

class JointGoal extends DataClass implements Insertable<JointGoal> {
  final String id;
  final String title;
  final int targetAmount;
  final int currentAmount;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JointGoal(
      {required this.id,
      required this.title,
      required this.targetAmount,
      required this.currentAmount,
      this.deadline,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['target_amount'] = Variable<int>(targetAmount);
    map['current_amount'] = Variable<int>(currentAmount);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JointGoalsCompanion toCompanion(bool nullToAbsent) {
    return JointGoalsCompanion(
      id: Value(id),
      title: Value(title),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JointGoal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JointGoal(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      currentAmount: serializer.fromJson<int>(json['currentAmount']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'currentAmount': serializer.toJson<int>(currentAmount),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JointGoal copyWith(
          {String? id,
          String? title,
          int? targetAmount,
          int? currentAmount,
          Value<DateTime?> deadline = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      JointGoal(
        id: id ?? this.id,
        title: title ?? this.title,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        deadline: deadline.present ? deadline.value : this.deadline,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  JointGoal copyWithCompanion(JointGoalsCompanion data) {
    return JointGoal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JointGoal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, targetAmount, currentAmount, deadline, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JointGoal &&
          other.id == this.id &&
          other.title == this.title &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JointGoalsCompanion extends UpdateCompanion<JointGoal> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> targetAmount;
  final Value<int> currentAmount;
  final Value<DateTime?> deadline;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JointGoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JointGoalsCompanion.insert({
    required String id,
    required String title,
    required int targetAmount,
    this.currentAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        targetAmount = Value(targetAmount),
        createdAt = Value(createdAt);
  static Insertable<JointGoal> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? targetAmount,
    Expression<int>? currentAmount,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JointGoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? targetAmount,
      Value<int>? currentAmount,
      Value<DateTime?>? deadline,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return JointGoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<int>(currentAmount.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JointGoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JointGoalMembersTable extends JointGoalMembers
    with TableInfo<$JointGoalMembersTable, JointGoalMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JointGoalMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memberNameMeta =
      const VerificationMeta('memberName');
  @override
  late final GeneratedColumn<String> memberName = GeneratedColumn<String>(
      'member_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contributedAmountMeta =
      const VerificationMeta('contributedAmount');
  @override
  late final GeneratedColumn<int> contributedAmount = GeneratedColumn<int>(
      'contributed_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _avatarIndexMeta =
      const VerificationMeta('avatarIndex');
  @override
  late final GeneratedColumn<int> avatarIndex = GeneratedColumn<int>(
      'avatar_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isCurrentUserMeta =
      const VerificationMeta('isCurrentUser');
  @override
  late final GeneratedColumn<bool> isCurrentUser = GeneratedColumn<bool>(
      'is_current_user', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_current_user" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        goalId,
        memberName,
        contributedAmount,
        avatarIndex,
        isCurrentUser,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'joint_goal_members';
  @override
  VerificationContext validateIntegrity(Insertable<JointGoalMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('member_name')) {
      context.handle(
          _memberNameMeta,
          memberName.isAcceptableOrUnknown(
              data['member_name']!, _memberNameMeta));
    } else if (isInserting) {
      context.missing(_memberNameMeta);
    }
    if (data.containsKey('contributed_amount')) {
      context.handle(
          _contributedAmountMeta,
          contributedAmount.isAcceptableOrUnknown(
              data['contributed_amount']!, _contributedAmountMeta));
    }
    if (data.containsKey('avatar_index')) {
      context.handle(
          _avatarIndexMeta,
          avatarIndex.isAcceptableOrUnknown(
              data['avatar_index']!, _avatarIndexMeta));
    }
    if (data.containsKey('is_current_user')) {
      context.handle(
          _isCurrentUserMeta,
          isCurrentUser.isAcceptableOrUnknown(
              data['is_current_user']!, _isCurrentUserMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JointGoalMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JointGoalMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      memberName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_name'])!,
      contributedAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}contributed_amount'])!,
      avatarIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avatar_index'])!,
      isCurrentUser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_current_user'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JointGoalMembersTable createAlias(String alias) {
    return $JointGoalMembersTable(attachedDatabase, alias);
  }
}

class JointGoalMember extends DataClass implements Insertable<JointGoalMember> {
  final String id;
  final String goalId;
  final String memberName;
  final int contributedAmount;
  final int avatarIndex;
  final bool isCurrentUser;
  final DateTime updatedAt;
  const JointGoalMember(
      {required this.id,
      required this.goalId,
      required this.memberName,
      required this.contributedAmount,
      required this.avatarIndex,
      required this.isCurrentUser,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['member_name'] = Variable<String>(memberName);
    map['contributed_amount'] = Variable<int>(contributedAmount);
    map['avatar_index'] = Variable<int>(avatarIndex);
    map['is_current_user'] = Variable<bool>(isCurrentUser);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JointGoalMembersCompanion toCompanion(bool nullToAbsent) {
    return JointGoalMembersCompanion(
      id: Value(id),
      goalId: Value(goalId),
      memberName: Value(memberName),
      contributedAmount: Value(contributedAmount),
      avatarIndex: Value(avatarIndex),
      isCurrentUser: Value(isCurrentUser),
      updatedAt: Value(updatedAt),
    );
  }

  factory JointGoalMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JointGoalMember(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      memberName: serializer.fromJson<String>(json['memberName']),
      contributedAmount: serializer.fromJson<int>(json['contributedAmount']),
      avatarIndex: serializer.fromJson<int>(json['avatarIndex']),
      isCurrentUser: serializer.fromJson<bool>(json['isCurrentUser']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'memberName': serializer.toJson<String>(memberName),
      'contributedAmount': serializer.toJson<int>(contributedAmount),
      'avatarIndex': serializer.toJson<int>(avatarIndex),
      'isCurrentUser': serializer.toJson<bool>(isCurrentUser),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JointGoalMember copyWith(
          {String? id,
          String? goalId,
          String? memberName,
          int? contributedAmount,
          int? avatarIndex,
          bool? isCurrentUser,
          DateTime? updatedAt}) =>
      JointGoalMember(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        memberName: memberName ?? this.memberName,
        contributedAmount: contributedAmount ?? this.contributedAmount,
        avatarIndex: avatarIndex ?? this.avatarIndex,
        isCurrentUser: isCurrentUser ?? this.isCurrentUser,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  JointGoalMember copyWithCompanion(JointGoalMembersCompanion data) {
    return JointGoalMember(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      memberName:
          data.memberName.present ? data.memberName.value : this.memberName,
      contributedAmount: data.contributedAmount.present
          ? data.contributedAmount.value
          : this.contributedAmount,
      avatarIndex:
          data.avatarIndex.present ? data.avatarIndex.value : this.avatarIndex,
      isCurrentUser: data.isCurrentUser.present
          ? data.isCurrentUser.value
          : this.isCurrentUser,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JointGoalMember(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('memberName: $memberName, ')
          ..write('contributedAmount: $contributedAmount, ')
          ..write('avatarIndex: $avatarIndex, ')
          ..write('isCurrentUser: $isCurrentUser, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, memberName, contributedAmount,
      avatarIndex, isCurrentUser, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JointGoalMember &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.memberName == this.memberName &&
          other.contributedAmount == this.contributedAmount &&
          other.avatarIndex == this.avatarIndex &&
          other.isCurrentUser == this.isCurrentUser &&
          other.updatedAt == this.updatedAt);
}

class JointGoalMembersCompanion extends UpdateCompanion<JointGoalMember> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> memberName;
  final Value<int> contributedAmount;
  final Value<int> avatarIndex;
  final Value<bool> isCurrentUser;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JointGoalMembersCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.memberName = const Value.absent(),
    this.contributedAmount = const Value.absent(),
    this.avatarIndex = const Value.absent(),
    this.isCurrentUser = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JointGoalMembersCompanion.insert({
    required String id,
    required String goalId,
    required String memberName,
    this.contributedAmount = const Value.absent(),
    this.avatarIndex = const Value.absent(),
    this.isCurrentUser = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        memberName = Value(memberName);
  static Insertable<JointGoalMember> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? memberName,
    Expression<int>? contributedAmount,
    Expression<int>? avatarIndex,
    Expression<bool>? isCurrentUser,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (memberName != null) 'member_name': memberName,
      if (contributedAmount != null) 'contributed_amount': contributedAmount,
      if (avatarIndex != null) 'avatar_index': avatarIndex,
      if (isCurrentUser != null) 'is_current_user': isCurrentUser,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JointGoalMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<String>? memberName,
      Value<int>? contributedAmount,
      Value<int>? avatarIndex,
      Value<bool>? isCurrentUser,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return JointGoalMembersCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      memberName: memberName ?? this.memberName,
      contributedAmount: contributedAmount ?? this.contributedAmount,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (memberName.present) {
      map['member_name'] = Variable<String>(memberName.value);
    }
    if (contributedAmount.present) {
      map['contributed_amount'] = Variable<int>(contributedAmount.value);
    }
    if (avatarIndex.present) {
      map['avatar_index'] = Variable<int>(avatarIndex.value);
    }
    if (isCurrentUser.present) {
      map['is_current_user'] = Variable<bool>(isCurrentUser.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JointGoalMembersCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('memberName: $memberName, ')
          ..write('contributedAmount: $contributedAmount, ')
          ..write('avatarIndex: $avatarIndex, ')
          ..write('isCurrentUser: $isCurrentUser, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvoidedPurchasesTable extends AvoidedPurchases
    with TableInfo<$AvoidedPurchasesTable, AvoidedPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvoidedPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, amount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'avoided_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<AvoidedPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AvoidedPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AvoidedPurchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AvoidedPurchasesTable createAlias(String alias) {
    return $AvoidedPurchasesTable(attachedDatabase, alias);
  }
}

class AvoidedPurchase extends DataClass implements Insertable<AvoidedPurchase> {
  final String id;
  final String title;
  final int amount;
  final DateTime createdAt;
  const AvoidedPurchase(
      {required this.id,
      required this.title,
      required this.amount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AvoidedPurchasesCompanion toCompanion(bool nullToAbsent) {
    return AvoidedPurchasesCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory AvoidedPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AvoidedPurchase(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AvoidedPurchase copyWith(
          {String? id, String? title, int? amount, DateTime? createdAt}) =>
      AvoidedPurchase(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        createdAt: createdAt ?? this.createdAt,
      );
  AvoidedPurchase copyWithCompanion(AvoidedPurchasesCompanion data) {
    return AvoidedPurchase(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AvoidedPurchase(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AvoidedPurchase &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class AvoidedPurchasesCompanion extends UpdateCompanion<AvoidedPurchase> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AvoidedPurchasesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AvoidedPurchasesCompanion.insert({
    required String id,
    required String title,
    required int amount,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        createdAt = Value(createdAt);
  static Insertable<AvoidedPurchase> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AvoidedPurchasesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? amount,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AvoidedPurchasesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvoidedPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryVaultEntriesTable extends MemoryVaultEntries
    with TableInfo<$MemoryVaultEntriesTable, MemoryVaultEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryVaultEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockThresholdPercentMeta =
      const VerificationMeta('unlockThresholdPercent');
  @override
  late final GeneratedColumn<int> unlockThresholdPercent = GeneratedColumn<int>(
      'unlock_threshold_percent', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isUnlockedMeta =
      const VerificationMeta('isUnlocked');
  @override
  late final GeneratedColumn<bool> isUnlocked = GeneratedColumn<bool>(
      'is_unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, goalId, unlockThresholdPercent, content, isUnlocked, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_vault_entries';
  @override
  VerificationContext validateIntegrity(Insertable<MemoryVaultEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('unlock_threshold_percent')) {
      context.handle(
          _unlockThresholdPercentMeta,
          unlockThresholdPercent.isAcceptableOrUnknown(
              data['unlock_threshold_percent']!, _unlockThresholdPercentMeta));
    } else if (isInserting) {
      context.missing(_unlockThresholdPercentMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('is_unlocked')) {
      context.handle(
          _isUnlockedMeta,
          isUnlocked.isAcceptableOrUnknown(
              data['is_unlocked']!, _isUnlockedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryVaultEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryVaultEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      unlockThresholdPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}unlock_threshold_percent'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content']),
      isUnlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_unlocked'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MemoryVaultEntriesTable createAlias(String alias) {
    return $MemoryVaultEntriesTable(attachedDatabase, alias);
  }
}

class MemoryVaultEntry extends DataClass
    implements Insertable<MemoryVaultEntry> {
  final String id;
  final String goalId;
  final int unlockThresholdPercent;
  final String? content;
  final bool isUnlocked;
  final DateTime createdAt;
  const MemoryVaultEntry(
      {required this.id,
      required this.goalId,
      required this.unlockThresholdPercent,
      this.content,
      required this.isUnlocked,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['unlock_threshold_percent'] = Variable<int>(unlockThresholdPercent);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['is_unlocked'] = Variable<bool>(isUnlocked);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MemoryVaultEntriesCompanion toCompanion(bool nullToAbsent) {
    return MemoryVaultEntriesCompanion(
      id: Value(id),
      goalId: Value(goalId),
      unlockThresholdPercent: Value(unlockThresholdPercent),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      isUnlocked: Value(isUnlocked),
      createdAt: Value(createdAt),
    );
  }

  factory MemoryVaultEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryVaultEntry(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      unlockThresholdPercent:
          serializer.fromJson<int>(json['unlockThresholdPercent']),
      content: serializer.fromJson<String?>(json['content']),
      isUnlocked: serializer.fromJson<bool>(json['isUnlocked']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'unlockThresholdPercent': serializer.toJson<int>(unlockThresholdPercent),
      'content': serializer.toJson<String?>(content),
      'isUnlocked': serializer.toJson<bool>(isUnlocked),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MemoryVaultEntry copyWith(
          {String? id,
          String? goalId,
          int? unlockThresholdPercent,
          Value<String?> content = const Value.absent(),
          bool? isUnlocked,
          DateTime? createdAt}) =>
      MemoryVaultEntry(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        unlockThresholdPercent:
            unlockThresholdPercent ?? this.unlockThresholdPercent,
        content: content.present ? content.value : this.content,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        createdAt: createdAt ?? this.createdAt,
      );
  MemoryVaultEntry copyWithCompanion(MemoryVaultEntriesCompanion data) {
    return MemoryVaultEntry(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      unlockThresholdPercent: data.unlockThresholdPercent.present
          ? data.unlockThresholdPercent.value
          : this.unlockThresholdPercent,
      content: data.content.present ? data.content.value : this.content,
      isUnlocked:
          data.isUnlocked.present ? data.isUnlocked.value : this.isUnlocked,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryVaultEntry(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('unlockThresholdPercent: $unlockThresholdPercent, ')
          ..write('content: $content, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, goalId, unlockThresholdPercent, content, isUnlocked, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryVaultEntry &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.unlockThresholdPercent == this.unlockThresholdPercent &&
          other.content == this.content &&
          other.isUnlocked == this.isUnlocked &&
          other.createdAt == this.createdAt);
}

class MemoryVaultEntriesCompanion extends UpdateCompanion<MemoryVaultEntry> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<int> unlockThresholdPercent;
  final Value<String?> content;
  final Value<bool> isUnlocked;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MemoryVaultEntriesCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.unlockThresholdPercent = const Value.absent(),
    this.content = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryVaultEntriesCompanion.insert({
    required String id,
    required String goalId,
    required int unlockThresholdPercent,
    this.content = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        unlockThresholdPercent = Value(unlockThresholdPercent),
        createdAt = Value(createdAt);
  static Insertable<MemoryVaultEntry> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<int>? unlockThresholdPercent,
    Expression<String>? content,
    Expression<bool>? isUnlocked,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (unlockThresholdPercent != null)
        'unlock_threshold_percent': unlockThresholdPercent,
      if (content != null) 'content': content,
      if (isUnlocked != null) 'is_unlocked': isUnlocked,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryVaultEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<int>? unlockThresholdPercent,
      Value<String?>? content,
      Value<bool>? isUnlocked,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MemoryVaultEntriesCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      unlockThresholdPercent:
          unlockThresholdPercent ?? this.unlockThresholdPercent,
      content: content ?? this.content,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (unlockThresholdPercent.present) {
      map['unlock_threshold_percent'] =
          Variable<int>(unlockThresholdPercent.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isUnlocked.present) {
      map['is_unlocked'] = Variable<bool>(isUnlocked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryVaultEntriesCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('unlockThresholdPercent: $unlockThresholdPercent, ')
          ..write('content: $content, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LendingContractsTable extends LendingContracts
    with TableInfo<$LendingContractsTable, LendingContract> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LendingContractsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _debtorNameMeta =
      const VerificationMeta('debtorName');
  @override
  late final GeneratedColumn<String> debtorName = GeneratedColumn<String>(
      'debtor_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _returnDateMeta =
      const VerificationMeta('returnDate');
  @override
  late final GeneratedColumn<DateTime> returnDate = GeneratedColumn<DateTime>(
      'return_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isReturnedMeta =
      const VerificationMeta('isReturned');
  @override
  late final GeneratedColumn<bool> isReturned = GeneratedColumn<bool>(
      'is_returned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_returned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, debtorName, amount, returnDate, isReturned, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lending_contracts';
  @override
  VerificationContext validateIntegrity(Insertable<LendingContract> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('debtor_name')) {
      context.handle(
          _debtorNameMeta,
          debtorName.isAcceptableOrUnknown(
              data['debtor_name']!, _debtorNameMeta));
    } else if (isInserting) {
      context.missing(_debtorNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('return_date')) {
      context.handle(
          _returnDateMeta,
          returnDate.isAcceptableOrUnknown(
              data['return_date']!, _returnDateMeta));
    } else if (isInserting) {
      context.missing(_returnDateMeta);
    }
    if (data.containsKey('is_returned')) {
      context.handle(
          _isReturnedMeta,
          isReturned.isAcceptableOrUnknown(
              data['is_returned']!, _isReturnedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LendingContract map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LendingContract(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      debtorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}debtor_name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      returnDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}return_date'])!,
      isReturned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_returned'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LendingContractsTable createAlias(String alias) {
    return $LendingContractsTable(attachedDatabase, alias);
  }
}

class LendingContract extends DataClass implements Insertable<LendingContract> {
  final String id;
  final String debtorName;
  final int amount;
  final DateTime returnDate;
  final bool isReturned;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LendingContract(
      {required this.id,
      required this.debtorName,
      required this.amount,
      required this.returnDate,
      required this.isReturned,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['debtor_name'] = Variable<String>(debtorName);
    map['amount'] = Variable<int>(amount);
    map['return_date'] = Variable<DateTime>(returnDate);
    map['is_returned'] = Variable<bool>(isReturned);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LendingContractsCompanion toCompanion(bool nullToAbsent) {
    return LendingContractsCompanion(
      id: Value(id),
      debtorName: Value(debtorName),
      amount: Value(amount),
      returnDate: Value(returnDate),
      isReturned: Value(isReturned),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LendingContract.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LendingContract(
      id: serializer.fromJson<String>(json['id']),
      debtorName: serializer.fromJson<String>(json['debtorName']),
      amount: serializer.fromJson<int>(json['amount']),
      returnDate: serializer.fromJson<DateTime>(json['returnDate']),
      isReturned: serializer.fromJson<bool>(json['isReturned']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'debtorName': serializer.toJson<String>(debtorName),
      'amount': serializer.toJson<int>(amount),
      'returnDate': serializer.toJson<DateTime>(returnDate),
      'isReturned': serializer.toJson<bool>(isReturned),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LendingContract copyWith(
          {String? id,
          String? debtorName,
          int? amount,
          DateTime? returnDate,
          bool? isReturned,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LendingContract(
        id: id ?? this.id,
        debtorName: debtorName ?? this.debtorName,
        amount: amount ?? this.amount,
        returnDate: returnDate ?? this.returnDate,
        isReturned: isReturned ?? this.isReturned,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LendingContract copyWithCompanion(LendingContractsCompanion data) {
    return LendingContract(
      id: data.id.present ? data.id.value : this.id,
      debtorName:
          data.debtorName.present ? data.debtorName.value : this.debtorName,
      amount: data.amount.present ? data.amount.value : this.amount,
      returnDate:
          data.returnDate.present ? data.returnDate.value : this.returnDate,
      isReturned:
          data.isReturned.present ? data.isReturned.value : this.isReturned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LendingContract(')
          ..write('id: $id, ')
          ..write('debtorName: $debtorName, ')
          ..write('amount: $amount, ')
          ..write('returnDate: $returnDate, ')
          ..write('isReturned: $isReturned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, debtorName, amount, returnDate, isReturned, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LendingContract &&
          other.id == this.id &&
          other.debtorName == this.debtorName &&
          other.amount == this.amount &&
          other.returnDate == this.returnDate &&
          other.isReturned == this.isReturned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LendingContractsCompanion extends UpdateCompanion<LendingContract> {
  final Value<String> id;
  final Value<String> debtorName;
  final Value<int> amount;
  final Value<DateTime> returnDate;
  final Value<bool> isReturned;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LendingContractsCompanion({
    this.id = const Value.absent(),
    this.debtorName = const Value.absent(),
    this.amount = const Value.absent(),
    this.returnDate = const Value.absent(),
    this.isReturned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LendingContractsCompanion.insert({
    required String id,
    required String debtorName,
    required int amount,
    required DateTime returnDate,
    this.isReturned = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        debtorName = Value(debtorName),
        amount = Value(amount),
        returnDate = Value(returnDate),
        createdAt = Value(createdAt);
  static Insertable<LendingContract> custom({
    Expression<String>? id,
    Expression<String>? debtorName,
    Expression<int>? amount,
    Expression<DateTime>? returnDate,
    Expression<bool>? isReturned,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtorName != null) 'debtor_name': debtorName,
      if (amount != null) 'amount': amount,
      if (returnDate != null) 'return_date': returnDate,
      if (isReturned != null) 'is_returned': isReturned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LendingContractsCompanion copyWith(
      {Value<String>? id,
      Value<String>? debtorName,
      Value<int>? amount,
      Value<DateTime>? returnDate,
      Value<bool>? isReturned,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LendingContractsCompanion(
      id: id ?? this.id,
      debtorName: debtorName ?? this.debtorName,
      amount: amount ?? this.amount,
      returnDate: returnDate ?? this.returnDate,
      isReturned: isReturned ?? this.isReturned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (debtorName.present) {
      map['debtor_name'] = Variable<String>(debtorName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (returnDate.present) {
      map['return_date'] = Variable<DateTime>(returnDate.value);
    }
    if (isReturned.present) {
      map['is_returned'] = Variable<bool>(isReturned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LendingContractsCompanion(')
          ..write('id: $id, ')
          ..write('debtorName: $debtorName, ')
          ..write('amount: $amount, ')
          ..write('returnDate: $returnDate, ')
          ..write('isReturned: $isReturned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, role, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final String role;
  final String content;
  final DateTime createdAt;
  const ChatMessage(
      {required this.id,
      required this.role,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChatMessage copyWith(
          {int? id, String? role, String? content, DateTime? createdAt}) =>
      ChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String role,
    required String content,
    this.createdAt = const Value.absent(),
  })  : role = Value(role),
        content = Value(content);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChatMessagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? role,
      Value<String>? content,
      Value<DateTime>? createdAt}) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InvestmentPortfolioTable extends InvestmentPortfolio
    with TableInfo<$InvestmentPortfolioTable, InvestmentPortfolioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentPortfolioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assetIdMeta =
      const VerificationMeta('assetId');
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
      'asset_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetNameMeta =
      const VerificationMeta('assetName');
  @override
  late final GeneratedColumn<String> assetName = GeneratedColumn<String>(
      'asset_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountOwnedMeta =
      const VerificationMeta('amountOwned');
  @override
  late final GeneratedColumn<int> amountOwned = GeneratedColumn<int>(
      'amount_owned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _averageBuyPriceMeta =
      const VerificationMeta('averageBuyPrice');
  @override
  late final GeneratedColumn<double> averageBuyPrice = GeneratedColumn<double>(
      'average_buy_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [assetId, assetName, amountOwned, averageBuyPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investment_portfolio';
  @override
  VerificationContext validateIntegrity(
      Insertable<InvestmentPortfolioData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('asset_id')) {
      context.handle(_assetIdMeta,
          assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta));
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('asset_name')) {
      context.handle(_assetNameMeta,
          assetName.isAcceptableOrUnknown(data['asset_name']!, _assetNameMeta));
    } else if (isInserting) {
      context.missing(_assetNameMeta);
    }
    if (data.containsKey('amount_owned')) {
      context.handle(
          _amountOwnedMeta,
          amountOwned.isAcceptableOrUnknown(
              data['amount_owned']!, _amountOwnedMeta));
    } else if (isInserting) {
      context.missing(_amountOwnedMeta);
    }
    if (data.containsKey('average_buy_price')) {
      context.handle(
          _averageBuyPriceMeta,
          averageBuyPrice.isAcceptableOrUnknown(
              data['average_buy_price']!, _averageBuyPriceMeta));
    } else if (isInserting) {
      context.missing(_averageBuyPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assetId};
  @override
  InvestmentPortfolioData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentPortfolioData(
      assetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_id'])!,
      assetName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_name'])!,
      amountOwned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_owned'])!,
      averageBuyPrice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}average_buy_price'])!,
    );
  }

  @override
  $InvestmentPortfolioTable createAlias(String alias) {
    return $InvestmentPortfolioTable(attachedDatabase, alias);
  }
}

class InvestmentPortfolioData extends DataClass
    implements Insertable<InvestmentPortfolioData> {
  final String assetId;
  final String assetName;
  final int amountOwned;
  final double averageBuyPrice;
  const InvestmentPortfolioData(
      {required this.assetId,
      required this.assetName,
      required this.amountOwned,
      required this.averageBuyPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['asset_id'] = Variable<String>(assetId);
    map['asset_name'] = Variable<String>(assetName);
    map['amount_owned'] = Variable<int>(amountOwned);
    map['average_buy_price'] = Variable<double>(averageBuyPrice);
    return map;
  }

  InvestmentPortfolioCompanion toCompanion(bool nullToAbsent) {
    return InvestmentPortfolioCompanion(
      assetId: Value(assetId),
      assetName: Value(assetName),
      amountOwned: Value(amountOwned),
      averageBuyPrice: Value(averageBuyPrice),
    );
  }

  factory InvestmentPortfolioData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentPortfolioData(
      assetId: serializer.fromJson<String>(json['assetId']),
      assetName: serializer.fromJson<String>(json['assetName']),
      amountOwned: serializer.fromJson<int>(json['amountOwned']),
      averageBuyPrice: serializer.fromJson<double>(json['averageBuyPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assetId': serializer.toJson<String>(assetId),
      'assetName': serializer.toJson<String>(assetName),
      'amountOwned': serializer.toJson<int>(amountOwned),
      'averageBuyPrice': serializer.toJson<double>(averageBuyPrice),
    };
  }

  InvestmentPortfolioData copyWith(
          {String? assetId,
          String? assetName,
          int? amountOwned,
          double? averageBuyPrice}) =>
      InvestmentPortfolioData(
        assetId: assetId ?? this.assetId,
        assetName: assetName ?? this.assetName,
        amountOwned: amountOwned ?? this.amountOwned,
        averageBuyPrice: averageBuyPrice ?? this.averageBuyPrice,
      );
  InvestmentPortfolioData copyWithCompanion(InvestmentPortfolioCompanion data) {
    return InvestmentPortfolioData(
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      assetName: data.assetName.present ? data.assetName.value : this.assetName,
      amountOwned:
          data.amountOwned.present ? data.amountOwned.value : this.amountOwned,
      averageBuyPrice: data.averageBuyPrice.present
          ? data.averageBuyPrice.value
          : this.averageBuyPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentPortfolioData(')
          ..write('assetId: $assetId, ')
          ..write('assetName: $assetName, ')
          ..write('amountOwned: $amountOwned, ')
          ..write('averageBuyPrice: $averageBuyPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(assetId, assetName, amountOwned, averageBuyPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentPortfolioData &&
          other.assetId == this.assetId &&
          other.assetName == this.assetName &&
          other.amountOwned == this.amountOwned &&
          other.averageBuyPrice == this.averageBuyPrice);
}

class InvestmentPortfolioCompanion
    extends UpdateCompanion<InvestmentPortfolioData> {
  final Value<String> assetId;
  final Value<String> assetName;
  final Value<int> amountOwned;
  final Value<double> averageBuyPrice;
  final Value<int> rowid;
  const InvestmentPortfolioCompanion({
    this.assetId = const Value.absent(),
    this.assetName = const Value.absent(),
    this.amountOwned = const Value.absent(),
    this.averageBuyPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentPortfolioCompanion.insert({
    required String assetId,
    required String assetName,
    required int amountOwned,
    required double averageBuyPrice,
    this.rowid = const Value.absent(),
  })  : assetId = Value(assetId),
        assetName = Value(assetName),
        amountOwned = Value(amountOwned),
        averageBuyPrice = Value(averageBuyPrice);
  static Insertable<InvestmentPortfolioData> custom({
    Expression<String>? assetId,
    Expression<String>? assetName,
    Expression<int>? amountOwned,
    Expression<double>? averageBuyPrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assetId != null) 'asset_id': assetId,
      if (assetName != null) 'asset_name': assetName,
      if (amountOwned != null) 'amount_owned': amountOwned,
      if (averageBuyPrice != null) 'average_buy_price': averageBuyPrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentPortfolioCompanion copyWith(
      {Value<String>? assetId,
      Value<String>? assetName,
      Value<int>? amountOwned,
      Value<double>? averageBuyPrice,
      Value<int>? rowid}) {
    return InvestmentPortfolioCompanion(
      assetId: assetId ?? this.assetId,
      assetName: assetName ?? this.assetName,
      amountOwned: amountOwned ?? this.amountOwned,
      averageBuyPrice: averageBuyPrice ?? this.averageBuyPrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (assetName.present) {
      map['asset_name'] = Variable<String>(assetName.value);
    }
    if (amountOwned.present) {
      map['amount_owned'] = Variable<int>(amountOwned.value);
    }
    if (averageBuyPrice.present) {
      map['average_buy_price'] = Variable<double>(averageBuyPrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentPortfolioCompanion(')
          ..write('assetId: $assetId, ')
          ..write('assetName: $assetName, ')
          ..write('amountOwned: $amountOwned, ')
          ..write('averageBuyPrice: $averageBuyPrice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MarketPricesTable extends MarketPrices
    with TableInfo<$MarketPricesTable, MarketPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [symbol, price, currency, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_prices';
  @override
  VerificationContext validateIntegrity(Insertable<MarketPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol};
  @override
  MarketPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketPrice(
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MarketPricesTable createAlias(String alias) {
    return $MarketPricesTable(attachedDatabase, alias);
  }
}

class MarketPrice extends DataClass implements Insertable<MarketPrice> {
  final String symbol;
  final double price;
  final String currency;
  final DateTime updatedAt;
  const MarketPrice(
      {required this.symbol,
      required this.price,
      required this.currency,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MarketPricesCompanion toCompanion(bool nullToAbsent) {
    return MarketPricesCompanion(
      symbol: Value(symbol),
      price: Value(price),
      currency: Value(currency),
      updatedAt: Value(updatedAt),
    );
  }

  factory MarketPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketPrice(
      symbol: serializer.fromJson<String>(json['symbol']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MarketPrice copyWith(
          {String? symbol,
          double? price,
          String? currency,
          DateTime? updatedAt}) =>
      MarketPrice(
        symbol: symbol ?? this.symbol,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MarketPrice copyWithCompanion(MarketPricesCompanion data) {
    return MarketPrice(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketPrice(')
          ..write('symbol: $symbol, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, price, currency, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketPrice &&
          other.symbol == this.symbol &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.updatedAt == this.updatedAt);
}

class MarketPricesCompanion extends UpdateCompanion<MarketPrice> {
  final Value<String> symbol;
  final Value<double> price;
  final Value<String> currency;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MarketPricesCompanion({
    this.symbol = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MarketPricesCompanion.insert({
    required String symbol,
    required double price,
    required String currency,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : symbol = Value(symbol),
        price = Value(price),
        currency = Value(currency),
        updatedAt = Value(updatedAt);
  static Insertable<MarketPrice> custom({
    Expression<String>? symbol,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MarketPricesCompanion copyWith(
      {Value<String>? symbol,
      Value<double>? price,
      Value<String>? currency,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MarketPricesCompanion(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketPricesCompanion(')
          ..write('symbol: $symbol, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceHistoryEntriesTable extends PriceHistoryEntries
    with TableInfo<$PriceHistoryEntriesTable, PriceHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceKopecksMeta =
      const VerificationMeta('priceKopecks');
  @override
  late final GeneratedColumn<int> priceKopecks = GeneratedColumn<int>(
      'price_kopecks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<String> store = GeneratedColumn<String>(
      'store', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SerpAPI'));
  static const VerificationMeta _dataSourceMeta =
      const VerificationMeta('dataSource');
  @override
  late final GeneratedColumn<String> dataSource = GeneratedColumn<String>(
      'data_source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('api'));
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, goalId, priceKopecks, store, dataSource, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_history_entries';
  @override
  VerificationContext validateIntegrity(Insertable<PriceHistoryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('price_kopecks')) {
      context.handle(
          _priceKopecksMeta,
          priceKopecks.isAcceptableOrUnknown(
              data['price_kopecks']!, _priceKopecksMeta));
    } else if (isInserting) {
      context.missing(_priceKopecksMeta);
    }
    if (data.containsKey('store')) {
      context.handle(
          _storeMeta, store.isAcceptableOrUnknown(data['store']!, _storeMeta));
    }
    if (data.containsKey('data_source')) {
      context.handle(
          _dataSourceMeta,
          dataSource.isAcceptableOrUnknown(
              data['data_source']!, _dataSourceMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceHistoryEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      priceKopecks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_kopecks'])!,
      store: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store'])!,
      dataSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_source'])!,
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $PriceHistoryEntriesTable createAlias(String alias) {
    return $PriceHistoryEntriesTable(attachedDatabase, alias);
  }
}

class PriceHistoryEntry extends DataClass
    implements Insertable<PriceHistoryEntry> {
  /// Auto-increment surrogate key.
  final int id;

  /// FK: references Goals.id. Not a Drift reference to avoid cascade issues
  /// when goals are soft-deleted.
  final String goalId;

  /// Price in kopecks (minor units, same convention as the rest of the app).
  final int priceKopecks;

  /// Store / source label (e.g. "Rozetka", "SerpAPI avg", "Manual").
  final String store;

  /// Data source: 'api' | 'manual' | 'cache'.
  final String dataSource;

  /// When this snapshot was recorded. Used for TTL checks and trend plotting.
  final DateTime cachedAt;
  const PriceHistoryEntry(
      {required this.id,
      required this.goalId,
      required this.priceKopecks,
      required this.store,
      required this.dataSource,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['price_kopecks'] = Variable<int>(priceKopecks);
    map['store'] = Variable<String>(store);
    map['data_source'] = Variable<String>(dataSource);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PriceHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return PriceHistoryEntriesCompanion(
      id: Value(id),
      goalId: Value(goalId),
      priceKopecks: Value(priceKopecks),
      store: Value(store),
      dataSource: Value(dataSource),
      cachedAt: Value(cachedAt),
    );
  }

  factory PriceHistoryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceHistoryEntry(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      priceKopecks: serializer.fromJson<int>(json['priceKopecks']),
      store: serializer.fromJson<String>(json['store']),
      dataSource: serializer.fromJson<String>(json['dataSource']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<String>(goalId),
      'priceKopecks': serializer.toJson<int>(priceKopecks),
      'store': serializer.toJson<String>(store),
      'dataSource': serializer.toJson<String>(dataSource),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PriceHistoryEntry copyWith(
          {int? id,
          String? goalId,
          int? priceKopecks,
          String? store,
          String? dataSource,
          DateTime? cachedAt}) =>
      PriceHistoryEntry(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        priceKopecks: priceKopecks ?? this.priceKopecks,
        store: store ?? this.store,
        dataSource: dataSource ?? this.dataSource,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  PriceHistoryEntry copyWithCompanion(PriceHistoryEntriesCompanion data) {
    return PriceHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      priceKopecks: data.priceKopecks.present
          ? data.priceKopecks.value
          : this.priceKopecks,
      store: data.store.present ? data.store.value : this.store,
      dataSource:
          data.dataSource.present ? data.dataSource.value : this.dataSource,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryEntry(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('priceKopecks: $priceKopecks, ')
          ..write('store: $store, ')
          ..write('dataSource: $dataSource, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, goalId, priceKopecks, store, dataSource, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceHistoryEntry &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.priceKopecks == this.priceKopecks &&
          other.store == this.store &&
          other.dataSource == this.dataSource &&
          other.cachedAt == this.cachedAt);
}

class PriceHistoryEntriesCompanion extends UpdateCompanion<PriceHistoryEntry> {
  final Value<int> id;
  final Value<String> goalId;
  final Value<int> priceKopecks;
  final Value<String> store;
  final Value<String> dataSource;
  final Value<DateTime> cachedAt;
  const PriceHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.priceKopecks = const Value.absent(),
    this.store = const Value.absent(),
    this.dataSource = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  PriceHistoryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String goalId,
    required int priceKopecks,
    this.store = const Value.absent(),
    this.dataSource = const Value.absent(),
    required DateTime cachedAt,
  })  : goalId = Value(goalId),
        priceKopecks = Value(priceKopecks),
        cachedAt = Value(cachedAt);
  static Insertable<PriceHistoryEntry> custom({
    Expression<int>? id,
    Expression<String>? goalId,
    Expression<int>? priceKopecks,
    Expression<String>? store,
    Expression<String>? dataSource,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (priceKopecks != null) 'price_kopecks': priceKopecks,
      if (store != null) 'store': store,
      if (dataSource != null) 'data_source': dataSource,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  PriceHistoryEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? goalId,
      Value<int>? priceKopecks,
      Value<String>? store,
      Value<String>? dataSource,
      Value<DateTime>? cachedAt}) {
    return PriceHistoryEntriesCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      priceKopecks: priceKopecks ?? this.priceKopecks,
      store: store ?? this.store,
      dataSource: dataSource ?? this.dataSource,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (priceKopecks.present) {
      map['price_kopecks'] = Variable<int>(priceKopecks.value);
    }
    if (store.present) {
      map['store'] = Variable<String>(store.value);
    }
    if (dataSource.present) {
      map['data_source'] = Variable<String>(dataSource.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('priceKopecks: $priceKopecks, ')
          ..write('store: $store, ')
          ..write('dataSource: $dataSource, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountKopecksMeta =
      const VerificationMeta('amountKopecks');
  @override
  late final GeneratedColumn<int> amountKopecks = GeneratedColumn<int>(
      'amount_kopecks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('UAH'));
  static const VerificationMeta _billingCycleMeta =
      const VerificationMeta('billingCycle');
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
      'billing_cycle', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _nextBillingDateMeta =
      const VerificationMeta('nextBillingDate');
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>('next_billing_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reminderDaysBeforeMeta =
      const VerificationMeta('reminderDaysBefore');
  @override
  late final GeneratedColumn<int> reminderDaysBefore = GeneratedColumn<int>(
      'reminder_days_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastCheckedAtMeta =
      const VerificationMeta('lastCheckedAt');
  @override
  late final GeneratedColumn<DateTime> lastCheckedAt =
      GeneratedColumn<DateTime>('last_checked_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amountKopecks,
        currency,
        billingCycle,
        nextBillingDate,
        reminderDaysBefore,
        isActive,
        lastCheckedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Subscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_kopecks')) {
      context.handle(
          _amountKopecksMeta,
          amountKopecks.isAcceptableOrUnknown(
              data['amount_kopecks']!, _amountKopecksMeta));
    } else if (isInserting) {
      context.missing(_amountKopecksMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
          _billingCycleMeta,
          billingCycle.isAcceptableOrUnknown(
              data['billing_cycle']!, _billingCycleMeta));
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
          _nextBillingDateMeta,
          nextBillingDate.isAcceptableOrUnknown(
              data['next_billing_date']!, _nextBillingDateMeta));
    } else if (isInserting) {
      context.missing(_nextBillingDateMeta);
    }
    if (data.containsKey('reminder_days_before')) {
      context.handle(
          _reminderDaysBeforeMeta,
          reminderDaysBefore.isAcceptableOrUnknown(
              data['reminder_days_before']!, _reminderDaysBeforeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
          _lastCheckedAtMeta,
          lastCheckedAt.isAcceptableOrUnknown(
              data['last_checked_at']!, _lastCheckedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amountKopecks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_kopecks'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      billingCycle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_cycle'])!,
      nextBillingDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_billing_date'])!,
      reminderDaysBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reminder_days_before'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastCheckedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_checked_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int id;
  final String name;
  final int amountKopecks;
  final String currency;
  final String billingCycle;
  final DateTime nextBillingDate;
  final int reminderDaysBefore;
  final bool isActive;
  final DateTime lastCheckedAt;
  final DateTime createdAt;
  const Subscription(
      {required this.id,
      required this.name,
      required this.amountKopecks,
      required this.currency,
      required this.billingCycle,
      required this.nextBillingDate,
      required this.reminderDaysBefore,
      required this.isActive,
      required this.lastCheckedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount_kopecks'] = Variable<int>(amountKopecks);
    map['currency'] = Variable<String>(currency);
    map['billing_cycle'] = Variable<String>(billingCycle);
    map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    map['reminder_days_before'] = Variable<int>(reminderDaysBefore);
    map['is_active'] = Variable<bool>(isActive);
    map['last_checked_at'] = Variable<DateTime>(lastCheckedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      name: Value(name),
      amountKopecks: Value(amountKopecks),
      currency: Value(currency),
      billingCycle: Value(billingCycle),
      nextBillingDate: Value(nextBillingDate),
      reminderDaysBefore: Value(reminderDaysBefore),
      isActive: Value(isActive),
      lastCheckedAt: Value(lastCheckedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountKopecks: serializer.fromJson<int>(json['amountKopecks']),
      currency: serializer.fromJson<String>(json['currency']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      nextBillingDate: serializer.fromJson<DateTime>(json['nextBillingDate']),
      reminderDaysBefore: serializer.fromJson<int>(json['reminderDaysBefore']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastCheckedAt: serializer.fromJson<DateTime>(json['lastCheckedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amountKopecks': serializer.toJson<int>(amountKopecks),
      'currency': serializer.toJson<String>(currency),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'nextBillingDate': serializer.toJson<DateTime>(nextBillingDate),
      'reminderDaysBefore': serializer.toJson<int>(reminderDaysBefore),
      'isActive': serializer.toJson<bool>(isActive),
      'lastCheckedAt': serializer.toJson<DateTime>(lastCheckedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Subscription copyWith(
          {int? id,
          String? name,
          int? amountKopecks,
          String? currency,
          String? billingCycle,
          DateTime? nextBillingDate,
          int? reminderDaysBefore,
          bool? isActive,
          DateTime? lastCheckedAt,
          DateTime? createdAt}) =>
      Subscription(
        id: id ?? this.id,
        name: name ?? this.name,
        amountKopecks: amountKopecks ?? this.amountKopecks,
        currency: currency ?? this.currency,
        billingCycle: billingCycle ?? this.billingCycle,
        nextBillingDate: nextBillingDate ?? this.nextBillingDate,
        reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
        isActive: isActive ?? this.isActive,
        lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountKopecks: data.amountKopecks.present
          ? data.amountKopecks.value
          : this.amountKopecks,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      reminderDaysBefore: data.reminderDaysBefore.present
          ? data.reminderDaysBefore.value
          : this.reminderDaysBefore,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountKopecks: $amountKopecks, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('isActive: $isActive, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      amountKopecks,
      currency,
      billingCycle,
      nextBillingDate,
      reminderDaysBefore,
      isActive,
      lastCheckedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountKopecks == this.amountKopecks &&
          other.currency == this.currency &&
          other.billingCycle == this.billingCycle &&
          other.nextBillingDate == this.nextBillingDate &&
          other.reminderDaysBefore == this.reminderDaysBefore &&
          other.isActive == this.isActive &&
          other.lastCheckedAt == this.lastCheckedAt &&
          other.createdAt == this.createdAt);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> amountKopecks;
  final Value<String> currency;
  final Value<String> billingCycle;
  final Value<DateTime> nextBillingDate;
  final Value<int> reminderDaysBefore;
  final Value<bool> isActive;
  final Value<DateTime> lastCheckedAt;
  final Value<DateTime> createdAt;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountKopecks = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.reminderDaysBefore = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int amountKopecks,
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    required DateTime nextBillingDate,
    this.reminderDaysBefore = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        amountKopecks = Value(amountKopecks),
        nextBillingDate = Value(nextBillingDate);
  static Insertable<Subscription> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? amountKopecks,
    Expression<String>? currency,
    Expression<String>? billingCycle,
    Expression<DateTime>? nextBillingDate,
    Expression<int>? reminderDaysBefore,
    Expression<bool>? isActive,
    Expression<DateTime>? lastCheckedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountKopecks != null) 'amount_kopecks': amountKopecks,
      if (currency != null) 'currency': currency,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (reminderDaysBefore != null)
        'reminder_days_before': reminderDaysBefore,
      if (isActive != null) 'is_active': isActive,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? amountKopecks,
      Value<String>? currency,
      Value<String>? billingCycle,
      Value<DateTime>? nextBillingDate,
      Value<int>? reminderDaysBefore,
      Value<bool>? isActive,
      Value<DateTime>? lastCheckedAt,
      Value<DateTime>? createdAt}) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountKopecks: amountKopecks ?? this.amountKopecks,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      isActive: isActive ?? this.isActive,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountKopecks.present) {
      map['amount_kopecks'] = Variable<int>(amountKopecks.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
    }
    if (reminderDaysBefore.present) {
      map['reminder_days_before'] = Variable<int>(reminderDaysBefore.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountKopecks: $amountKopecks, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('isActive: $isActive, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GiftGoalsTable extends GiftGoals
    with TableInfo<$GiftGoalsTable, GiftGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GiftGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientNameMeta =
      const VerificationMeta('recipientName');
  @override
  late final GeneratedColumn<String> recipientName = GeneratedColumn<String>(
      'recipient_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientRelationshipMeta =
      const VerificationMeta('recipientRelationship');
  @override
  late final GeneratedColumn<String> recipientRelationship =
      GeneratedColumn<String>('recipient_relationship', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occasionTypeMeta =
      const VerificationMeta('occasionType');
  @override
  late final GeneratedColumn<String> occasionType = GeneratedColumn<String>(
      'occasion_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occasionDateMeta =
      const VerificationMeta('occasionDate');
  @override
  late final GeneratedColumn<DateTime> occasionDate = GeneratedColumn<DateTime>(
      'occasion_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('🎁'));
  static const VerificationMeta _personalizedMessageMeta =
      const VerificationMeta('personalizedMessage');
  @override
  late final GeneratedColumn<String> personalizedMessage =
      GeneratedColumn<String>('personalized_message', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSurpriseModeMeta =
      const VerificationMeta('isSurpriseMode');
  @override
  late final GeneratedColumn<bool> isSurpriseMode = GeneratedColumn<bool>(
      'is_surprise_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_surprise_mode" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        goalId,
        recipientName,
        recipientRelationship,
        occasionType,
        occasionDate,
        emoji,
        personalizedMessage,
        isSurpriseMode,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gift_goals';
  @override
  VerificationContext validateIntegrity(Insertable<GiftGoal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('recipient_name')) {
      context.handle(
          _recipientNameMeta,
          recipientName.isAcceptableOrUnknown(
              data['recipient_name']!, _recipientNameMeta));
    } else if (isInserting) {
      context.missing(_recipientNameMeta);
    }
    if (data.containsKey('recipient_relationship')) {
      context.handle(
          _recipientRelationshipMeta,
          recipientRelationship.isAcceptableOrUnknown(
              data['recipient_relationship']!, _recipientRelationshipMeta));
    } else if (isInserting) {
      context.missing(_recipientRelationshipMeta);
    }
    if (data.containsKey('occasion_type')) {
      context.handle(
          _occasionTypeMeta,
          occasionType.isAcceptableOrUnknown(
              data['occasion_type']!, _occasionTypeMeta));
    } else if (isInserting) {
      context.missing(_occasionTypeMeta);
    }
    if (data.containsKey('occasion_date')) {
      context.handle(
          _occasionDateMeta,
          occasionDate.isAcceptableOrUnknown(
              data['occasion_date']!, _occasionDateMeta));
    } else if (isInserting) {
      context.missing(_occasionDateMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    if (data.containsKey('personalized_message')) {
      context.handle(
          _personalizedMessageMeta,
          personalizedMessage.isAcceptableOrUnknown(
              data['personalized_message']!, _personalizedMessageMeta));
    }
    if (data.containsKey('is_surprise_mode')) {
      context.handle(
          _isSurpriseModeMeta,
          isSurpriseMode.isAcceptableOrUnknown(
              data['is_surprise_mode']!, _isSurpriseModeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GiftGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GiftGoal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      recipientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient_name'])!,
      recipientRelationship: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recipient_relationship'])!,
      occasionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}occasion_type'])!,
      occasionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}occasion_date'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      personalizedMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}personalized_message']),
      isSurpriseMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_surprise_mode'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GiftGoalsTable createAlias(String alias) {
    return $GiftGoalsTable(attachedDatabase, alias);
  }
}

class GiftGoal extends DataClass implements Insertable<GiftGoal> {
  final String id;
  final String goalId;
  final String recipientName;
  final String recipientRelationship;
  final String occasionType;
  final DateTime occasionDate;
  final String emoji;
  final String? personalizedMessage;
  final bool isSurpriseMode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GiftGoal(
      {required this.id,
      required this.goalId,
      required this.recipientName,
      required this.recipientRelationship,
      required this.occasionType,
      required this.occasionDate,
      required this.emoji,
      this.personalizedMessage,
      required this.isSurpriseMode,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['recipient_name'] = Variable<String>(recipientName);
    map['recipient_relationship'] = Variable<String>(recipientRelationship);
    map['occasion_type'] = Variable<String>(occasionType);
    map['occasion_date'] = Variable<DateTime>(occasionDate);
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || personalizedMessage != null) {
      map['personalized_message'] = Variable<String>(personalizedMessage);
    }
    map['is_surprise_mode'] = Variable<bool>(isSurpriseMode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GiftGoalsCompanion toCompanion(bool nullToAbsent) {
    return GiftGoalsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      recipientName: Value(recipientName),
      recipientRelationship: Value(recipientRelationship),
      occasionType: Value(occasionType),
      occasionDate: Value(occasionDate),
      emoji: Value(emoji),
      personalizedMessage: personalizedMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(personalizedMessage),
      isSurpriseMode: Value(isSurpriseMode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GiftGoal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GiftGoal(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      recipientName: serializer.fromJson<String>(json['recipientName']),
      recipientRelationship:
          serializer.fromJson<String>(json['recipientRelationship']),
      occasionType: serializer.fromJson<String>(json['occasionType']),
      occasionDate: serializer.fromJson<DateTime>(json['occasionDate']),
      emoji: serializer.fromJson<String>(json['emoji']),
      personalizedMessage:
          serializer.fromJson<String?>(json['personalizedMessage']),
      isSurpriseMode: serializer.fromJson<bool>(json['isSurpriseMode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'recipientName': serializer.toJson<String>(recipientName),
      'recipientRelationship': serializer.toJson<String>(recipientRelationship),
      'occasionType': serializer.toJson<String>(occasionType),
      'occasionDate': serializer.toJson<DateTime>(occasionDate),
      'emoji': serializer.toJson<String>(emoji),
      'personalizedMessage': serializer.toJson<String?>(personalizedMessage),
      'isSurpriseMode': serializer.toJson<bool>(isSurpriseMode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GiftGoal copyWith(
          {String? id,
          String? goalId,
          String? recipientName,
          String? recipientRelationship,
          String? occasionType,
          DateTime? occasionDate,
          String? emoji,
          Value<String?> personalizedMessage = const Value.absent(),
          bool? isSurpriseMode,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      GiftGoal(
        id: id ?? this.id,
        goalId: goalId ?? this.goalId,
        recipientName: recipientName ?? this.recipientName,
        recipientRelationship:
            recipientRelationship ?? this.recipientRelationship,
        occasionType: occasionType ?? this.occasionType,
        occasionDate: occasionDate ?? this.occasionDate,
        emoji: emoji ?? this.emoji,
        personalizedMessage: personalizedMessage.present
            ? personalizedMessage.value
            : this.personalizedMessage,
        isSurpriseMode: isSurpriseMode ?? this.isSurpriseMode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  GiftGoal copyWithCompanion(GiftGoalsCompanion data) {
    return GiftGoal(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      recipientName: data.recipientName.present
          ? data.recipientName.value
          : this.recipientName,
      recipientRelationship: data.recipientRelationship.present
          ? data.recipientRelationship.value
          : this.recipientRelationship,
      occasionType: data.occasionType.present
          ? data.occasionType.value
          : this.occasionType,
      occasionDate: data.occasionDate.present
          ? data.occasionDate.value
          : this.occasionDate,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      personalizedMessage: data.personalizedMessage.present
          ? data.personalizedMessage.value
          : this.personalizedMessage,
      isSurpriseMode: data.isSurpriseMode.present
          ? data.isSurpriseMode.value
          : this.isSurpriseMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GiftGoal(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientRelationship: $recipientRelationship, ')
          ..write('occasionType: $occasionType, ')
          ..write('occasionDate: $occasionDate, ')
          ..write('emoji: $emoji, ')
          ..write('personalizedMessage: $personalizedMessage, ')
          ..write('isSurpriseMode: $isSurpriseMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      goalId,
      recipientName,
      recipientRelationship,
      occasionType,
      occasionDate,
      emoji,
      personalizedMessage,
      isSurpriseMode,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GiftGoal &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.recipientName == this.recipientName &&
          other.recipientRelationship == this.recipientRelationship &&
          other.occasionType == this.occasionType &&
          other.occasionDate == this.occasionDate &&
          other.emoji == this.emoji &&
          other.personalizedMessage == this.personalizedMessage &&
          other.isSurpriseMode == this.isSurpriseMode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GiftGoalsCompanion extends UpdateCompanion<GiftGoal> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> recipientName;
  final Value<String> recipientRelationship;
  final Value<String> occasionType;
  final Value<DateTime> occasionDate;
  final Value<String> emoji;
  final Value<String?> personalizedMessage;
  final Value<bool> isSurpriseMode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GiftGoalsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.recipientName = const Value.absent(),
    this.recipientRelationship = const Value.absent(),
    this.occasionType = const Value.absent(),
    this.occasionDate = const Value.absent(),
    this.emoji = const Value.absent(),
    this.personalizedMessage = const Value.absent(),
    this.isSurpriseMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GiftGoalsCompanion.insert({
    required String id,
    required String goalId,
    required String recipientName,
    required String recipientRelationship,
    required String occasionType,
    required DateTime occasionDate,
    this.emoji = const Value.absent(),
    this.personalizedMessage = const Value.absent(),
    this.isSurpriseMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        goalId = Value(goalId),
        recipientName = Value(recipientName),
        recipientRelationship = Value(recipientRelationship),
        occasionType = Value(occasionType),
        occasionDate = Value(occasionDate);
  static Insertable<GiftGoal> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? recipientName,
    Expression<String>? recipientRelationship,
    Expression<String>? occasionType,
    Expression<DateTime>? occasionDate,
    Expression<String>? emoji,
    Expression<String>? personalizedMessage,
    Expression<bool>? isSurpriseMode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (recipientName != null) 'recipient_name': recipientName,
      if (recipientRelationship != null)
        'recipient_relationship': recipientRelationship,
      if (occasionType != null) 'occasion_type': occasionType,
      if (occasionDate != null) 'occasion_date': occasionDate,
      if (emoji != null) 'emoji': emoji,
      if (personalizedMessage != null)
        'personalized_message': personalizedMessage,
      if (isSurpriseMode != null) 'is_surprise_mode': isSurpriseMode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GiftGoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? goalId,
      Value<String>? recipientName,
      Value<String>? recipientRelationship,
      Value<String>? occasionType,
      Value<DateTime>? occasionDate,
      Value<String>? emoji,
      Value<String?>? personalizedMessage,
      Value<bool>? isSurpriseMode,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return GiftGoalsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      recipientName: recipientName ?? this.recipientName,
      recipientRelationship:
          recipientRelationship ?? this.recipientRelationship,
      occasionType: occasionType ?? this.occasionType,
      occasionDate: occasionDate ?? this.occasionDate,
      emoji: emoji ?? this.emoji,
      personalizedMessage: personalizedMessage ?? this.personalizedMessage,
      isSurpriseMode: isSurpriseMode ?? this.isSurpriseMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (recipientName.present) {
      map['recipient_name'] = Variable<String>(recipientName.value);
    }
    if (recipientRelationship.present) {
      map['recipient_relationship'] =
          Variable<String>(recipientRelationship.value);
    }
    if (occasionType.present) {
      map['occasion_type'] = Variable<String>(occasionType.value);
    }
    if (occasionDate.present) {
      map['occasion_date'] = Variable<DateTime>(occasionDate.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (personalizedMessage.present) {
      map['personalized_message'] = Variable<String>(personalizedMessage.value);
    }
    if (isSurpriseMode.present) {
      map['is_surprise_mode'] = Variable<bool>(isSurpriseMode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GiftGoalsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientRelationship: $recipientRelationship, ')
          ..write('occasionType: $occasionType, ')
          ..write('occasionDate: $occasionDate, ')
          ..write('emoji: $emoji, ')
          ..write('personalizedMessage: $personalizedMessage, ')
          ..write('isSurpriseMode: $isSurpriseMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $DepositsTable deposits = $DepositsTable(this);
  late final $DepositAllocationsTable depositAllocations =
      $DepositAllocationsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $UnlockedAchievementsTable unlockedAchievements =
      $UnlockedAchievementsTable(this);
  late final $UnlockedSkillsTable unlockedSkills = $UnlockedSkillsTable(this);
  late final $LootboxesTable lootboxes = $LootboxesTable(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $SquadsTable squads = $SquadsTable(this);
  late final $SideQuestsTable sideQuests = $SideQuestsTable(this);
  late final $TransactionTagsTable transactionTags =
      $TransactionTagsTable(this);
  late final $VoiceLogsTable voiceLogs = $VoiceLogsTable(this);
  late final $PenaltyHabitsTable penaltyHabits = $PenaltyHabitsTable(this);
  late final $JointGoalsTable jointGoals = $JointGoalsTable(this);
  late final $JointGoalMembersTable jointGoalMembers =
      $JointGoalMembersTable(this);
  late final $AvoidedPurchasesTable avoidedPurchases =
      $AvoidedPurchasesTable(this);
  late final $MemoryVaultEntriesTable memoryVaultEntries =
      $MemoryVaultEntriesTable(this);
  late final $LendingContractsTable lendingContracts =
      $LendingContractsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $InvestmentPortfolioTable investmentPortfolio =
      $InvestmentPortfolioTable(this);
  late final $MarketPricesTable marketPrices = $MarketPricesTable(this);
  late final $PriceHistoryEntriesTable priceHistoryEntries =
      $PriceHistoryEntriesTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $GiftGoalsTable giftGoals = $GiftGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        goals,
        deposits,
        depositAllocations,
        userProfiles,
        unlockedAchievements,
        unlockedSkills,
        lootboxes,
        pets,
        squads,
        sideQuests,
        transactionTags,
        voiceLogs,
        penaltyHabits,
        jointGoals,
        jointGoalMembers,
        avoidedPurchases,
        memoryVaultEntries,
        lendingContracts,
        chatMessages,
        investmentPortfolio,
        marketPrices,
        priceHistoryEntries,
        subscriptions,
        giftGoals
      ];
}

typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String name,
  required int targetAmount,
  required int currentAmount,
  required String currency,
  required String accentColor,
  required DateTime createdAt,
  Value<DateTime> updatedAt,
  Value<String?> productUrl,
  Value<int?> targetPrice,
  Value<int?> currentPrice,
  Value<int> priceShieldHp,
  Value<DateTime?> lastPriceUpdate,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> targetAmount,
  Value<int> currentAmount,
  Value<String> currency,
  Value<String> accentColor,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> productUrl,
  Value<int?> targetPrice,
  Value<int?> currentPrice,
  Value<int> priceShieldHp,
  Value<DateTime?> lastPriceUpdate,
  Value<int> rowid,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DepositAllocationsTable, List<DepositAllocation>>
      _depositAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.depositAllocations,
              aliasName: $_aliasNameGenerator(
                  db.goals.id, db.depositAllocations.goalId));

  $$DepositAllocationsTableProcessedTableManager get depositAllocationsRefs {
    final manager =
        $$DepositAllocationsTableTableManager($_db, $_db.depositAllocations)
            .filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_depositAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accentColor => $composableBuilder(
      column: $table.accentColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productUrl => $composableBuilder(
      column: $table.productUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceShieldHp => $composableBuilder(
      column: $table.priceShieldHp, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPriceUpdate => $composableBuilder(
      column: $table.lastPriceUpdate,
      builder: (column) => ColumnFilters(column));

  Expression<bool> depositAllocationsRefs(
      Expression<bool> Function($$DepositAllocationsTableFilterComposer f) f) {
    final $$DepositAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.depositAllocations,
        getReferencedColumn: (t) => t.goalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.depositAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accentColor => $composableBuilder(
      column: $table.accentColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productUrl => $composableBuilder(
      column: $table.productUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentPrice => $composableBuilder(
      column: $table.currentPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceShieldHp => $composableBuilder(
      column: $table.priceShieldHp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPriceUpdate => $composableBuilder(
      column: $table.lastPriceUpdate,
      builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<int> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get accentColor => $composableBuilder(
      column: $table.accentColor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get productUrl => $composableBuilder(
      column: $table.productUrl, builder: (column) => column);

  GeneratedColumn<int> get targetPrice => $composableBuilder(
      column: $table.targetPrice, builder: (column) => column);

  GeneratedColumn<int> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => column);

  GeneratedColumn<int> get priceShieldHp => $composableBuilder(
      column: $table.priceShieldHp, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPriceUpdate => $composableBuilder(
      column: $table.lastPriceUpdate, builder: (column) => column);

  Expression<T> depositAllocationsRefs<T extends Object>(
      Expression<T> Function($$DepositAllocationsTableAnnotationComposer a) f) {
    final $$DepositAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.depositAllocations,
            getReferencedColumn: (t) => t.goalId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DepositAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.depositAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function({bool depositAllocationsRefs})> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> targetAmount = const Value.absent(),
            Value<int> currentAmount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> accentColor = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> productUrl = const Value.absent(),
            Value<int?> targetPrice = const Value.absent(),
            Value<int?> currentPrice = const Value.absent(),
            Value<int> priceShieldHp = const Value.absent(),
            Value<DateTime?> lastPriceUpdate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            currency: currency,
            accentColor: accentColor,
            createdAt: createdAt,
            updatedAt: updatedAt,
            productUrl: productUrl,
            targetPrice: targetPrice,
            currentPrice: currentPrice,
            priceShieldHp: priceShieldHp,
            lastPriceUpdate: lastPriceUpdate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int targetAmount,
            required int currentAmount,
            required String currency,
            required String accentColor,
            required DateTime createdAt,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> productUrl = const Value.absent(),
            Value<int?> targetPrice = const Value.absent(),
            Value<int?> currentPrice = const Value.absent(),
            Value<int> priceShieldHp = const Value.absent(),
            Value<DateTime?> lastPriceUpdate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            id: id,
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            currency: currency,
            accentColor: accentColor,
            createdAt: createdAt,
            updatedAt: updatedAt,
            productUrl: productUrl,
            targetPrice: targetPrice,
            currentPrice: currentPrice,
            priceShieldHp: priceShieldHp,
            lastPriceUpdate: lastPriceUpdate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GoalsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({depositAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (depositAllocationsRefs) db.depositAllocations
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (depositAllocationsRefs)
                    await $_getPrefetchedData<Goal, $GoalsTable,
                            DepositAllocation>(
                        currentTable: table,
                        referencedTable: $$GoalsTableReferences
                            ._depositAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GoalsTableReferences(db, table, p0)
                                .depositAllocationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.goalId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTable,
    Goal,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableAnnotationComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder,
    (Goal, $$GoalsTableReferences),
    Goal,
    PrefetchHooks Function({bool depositAllocationsRefs})>;
typedef $$DepositsTableCreateCompanionBuilder = DepositsCompanion Function({
  required String id,
  required int amount,
  Value<String?> note,
  required DateTime createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$DepositsTableUpdateCompanionBuilder = DepositsCompanion Function({
  Value<String> id,
  Value<int> amount,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

final class $$DepositsTableReferences
    extends BaseReferences<_$AppDatabase, $DepositsTable, Deposit> {
  $$DepositsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DepositAllocationsTable, List<DepositAllocation>>
      _depositAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.depositAllocations,
              aliasName: $_aliasNameGenerator(
                  db.deposits.id, db.depositAllocations.depositId));

  $$DepositAllocationsTableProcessedTableManager get depositAllocationsRefs {
    final manager = $$DepositAllocationsTableTableManager(
            $_db, $_db.depositAllocations)
        .filter((f) => f.depositId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_depositAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DepositsTableFilterComposer
    extends Composer<_$AppDatabase, $DepositsTable> {
  $$DepositsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  Expression<bool> depositAllocationsRefs(
      Expression<bool> Function($$DepositAllocationsTableFilterComposer f) f) {
    final $$DepositAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.depositAllocations,
        getReferencedColumn: (t) => t.depositId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.depositAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DepositsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepositsTable> {
  $$DepositsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$DepositsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepositsTable> {
  $$DepositsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> depositAllocationsRefs<T extends Object>(
      Expression<T> Function($$DepositAllocationsTableAnnotationComposer a) f) {
    final $$DepositAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.depositAllocations,
            getReferencedColumn: (t) => t.depositId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DepositAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.depositAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DepositsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DepositsTable,
    Deposit,
    $$DepositsTableFilterComposer,
    $$DepositsTableOrderingComposer,
    $$DepositsTableAnnotationComposer,
    $$DepositsTableCreateCompanionBuilder,
    $$DepositsTableUpdateCompanionBuilder,
    (Deposit, $$DepositsTableReferences),
    Deposit,
    PrefetchHooks Function({bool depositAllocationsRefs})> {
  $$DepositsTableTableManager(_$AppDatabase db, $DepositsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepositsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepositsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepositsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DepositsCompanion(
            id: id,
            amount: amount,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int amount,
            Value<String?> note = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DepositsCompanion.insert(
            id: id,
            amount: amount,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DepositsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({depositAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (depositAllocationsRefs) db.depositAllocations
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (depositAllocationsRefs)
                    await $_getPrefetchedData<Deposit, $DepositsTable,
                            DepositAllocation>(
                        currentTable: table,
                        referencedTable: $$DepositsTableReferences
                            ._depositAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DepositsTableReferences(db, table, p0)
                                .depositAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.depositId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DepositsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DepositsTable,
    Deposit,
    $$DepositsTableFilterComposer,
    $$DepositsTableOrderingComposer,
    $$DepositsTableAnnotationComposer,
    $$DepositsTableCreateCompanionBuilder,
    $$DepositsTableUpdateCompanionBuilder,
    (Deposit, $$DepositsTableReferences),
    Deposit,
    PrefetchHooks Function({bool depositAllocationsRefs})>;
typedef $$DepositAllocationsTableCreateCompanionBuilder
    = DepositAllocationsCompanion Function({
  required String id,
  required String depositId,
  required String goalId,
  required int amount,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DepositAllocationsTableUpdateCompanionBuilder
    = DepositAllocationsCompanion Function({
  Value<String> id,
  Value<String> depositId,
  Value<String> goalId,
  Value<int> amount,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$DepositAllocationsTableReferences extends BaseReferences<
    _$AppDatabase, $DepositAllocationsTable, DepositAllocation> {
  $$DepositAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DepositsTable _depositIdTable(_$AppDatabase db) =>
      db.deposits.createAlias($_aliasNameGenerator(
          db.depositAllocations.depositId, db.deposits.id));

  $$DepositsTableProcessedTableManager get depositId {
    final $_column = $_itemColumn<String>('deposit_id')!;

    final manager = $$DepositsTableTableManager($_db, $_db.deposits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_depositIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GoalsTable _goalIdTable(_$AppDatabase db) => db.goals.createAlias(
      $_aliasNameGenerator(db.depositAllocations.goalId, db.goals.id));

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$GoalsTableTableManager($_db, $_db.goals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DepositAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $DepositAllocationsTable> {
  $$DepositAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DepositsTableFilterComposer get depositId {
    final $$DepositsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.depositId,
        referencedTable: $db.deposits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositsTableFilterComposer(
              $db: $db,
              $table: $db.deposits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableFilterComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DepositAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepositAllocationsTable> {
  $$DepositAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DepositsTableOrderingComposer get depositId {
    final $$DepositsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.depositId,
        referencedTable: $db.deposits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositsTableOrderingComposer(
              $db: $db,
              $table: $db.deposits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableOrderingComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DepositAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepositAllocationsTable> {
  $$DepositAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DepositsTableAnnotationComposer get depositId {
    final $$DepositsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.depositId,
        referencedTable: $db.deposits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DepositsTableAnnotationComposer(
              $db: $db,
              $table: $db.deposits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.goalId,
        referencedTable: $db.goals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.goals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DepositAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DepositAllocationsTable,
    DepositAllocation,
    $$DepositAllocationsTableFilterComposer,
    $$DepositAllocationsTableOrderingComposer,
    $$DepositAllocationsTableAnnotationComposer,
    $$DepositAllocationsTableCreateCompanionBuilder,
    $$DepositAllocationsTableUpdateCompanionBuilder,
    (DepositAllocation, $$DepositAllocationsTableReferences),
    DepositAllocation,
    PrefetchHooks Function({bool depositId, bool goalId})> {
  $$DepositAllocationsTableTableManager(
      _$AppDatabase db, $DepositAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepositAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepositAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepositAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> depositId = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DepositAllocationsCompanion(
            id: id,
            depositId: depositId,
            goalId: goalId,
            amount: amount,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String depositId,
            required String goalId,
            required int amount,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DepositAllocationsCompanion.insert(
            id: id,
            depositId: depositId,
            goalId: goalId,
            amount: amount,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DepositAllocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({depositId = false, goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (depositId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.depositId,
                    referencedTable:
                        $$DepositAllocationsTableReferences._depositIdTable(db),
                    referencedColumn: $$DepositAllocationsTableReferences
                        ._depositIdTable(db)
                        .id,
                  ) as T;
                }
                if (goalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.goalId,
                    referencedTable:
                        $$DepositAllocationsTableReferences._goalIdTable(db),
                    referencedColumn:
                        $$DepositAllocationsTableReferences._goalIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DepositAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DepositAllocationsTable,
    DepositAllocation,
    $$DepositAllocationsTableFilterComposer,
    $$DepositAllocationsTableOrderingComposer,
    $$DepositAllocationsTableAnnotationComposer,
    $$DepositAllocationsTableCreateCompanionBuilder,
    $$DepositAllocationsTableUpdateCompanionBuilder,
    (DepositAllocation, $$DepositAllocationsTableReferences),
    DepositAllocation,
    PrefetchHooks Function({bool depositId, bool goalId})>;
typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<int> xp,
  Value<int> level,
  Value<int> streakCount,
  Value<int> maxStreak,
  Value<int> freezeTokens,
  Value<DateTime?> lastDepositDate,
  Value<int> skillPoints,
  Value<String?> playerClass,
  Value<String> currentTheme,
  Value<String?> avatarConfig,
  Value<int> penaltyBalance,
  Value<int> hackerXp,
  Value<int> magnateXp,
  Value<int> resilienceXp,
  Value<DateTime?> lastBonusClaimDate,
  Value<int> bonusStreak,
  Value<int> crystalsBalance,
  Value<int> noSpendStreakCount,
  Value<DateTime?> lastNoSpendDate,
  Value<DateTime> updatedAt,
  Value<int> karmaDebt,
  Value<DateTime?> debuffActiveUntil,
  Value<String?> partnerName,
  Value<DateTime?> partnerLastDepositDate,
  Value<DateTime?> lastDiversificationXPDate,
  Value<DateTime?> lastRebalanceXPDate,
  Value<DateTime?> lastPricePulseXPDate,
  Value<int> pricePulseTrackingCount,
  Value<int> karmaHealingStreakCount,
  Value<DateTime?> lastKarmaHealDate,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<int> xp,
  Value<int> level,
  Value<int> streakCount,
  Value<int> maxStreak,
  Value<int> freezeTokens,
  Value<DateTime?> lastDepositDate,
  Value<int> skillPoints,
  Value<String?> playerClass,
  Value<String> currentTheme,
  Value<String?> avatarConfig,
  Value<int> penaltyBalance,
  Value<int> hackerXp,
  Value<int> magnateXp,
  Value<int> resilienceXp,
  Value<DateTime?> lastBonusClaimDate,
  Value<int> bonusStreak,
  Value<int> crystalsBalance,
  Value<int> noSpendStreakCount,
  Value<DateTime?> lastNoSpendDate,
  Value<DateTime> updatedAt,
  Value<int> karmaDebt,
  Value<DateTime?> debuffActiveUntil,
  Value<String?> partnerName,
  Value<DateTime?> partnerLastDepositDate,
  Value<DateTime?> lastDiversificationXPDate,
  Value<DateTime?> lastRebalanceXPDate,
  Value<DateTime?> lastPricePulseXPDate,
  Value<int> pricePulseTrackingCount,
  Value<int> karmaHealingStreakCount,
  Value<DateTime?> lastKarmaHealDate,
});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streakCount => $composableBuilder(
      column: $table.streakCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxStreak => $composableBuilder(
      column: $table.maxStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get freezeTokens => $composableBuilder(
      column: $table.freezeTokens, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastDepositDate => $composableBuilder(
      column: $table.lastDepositDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get skillPoints => $composableBuilder(
      column: $table.skillPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerClass => $composableBuilder(
      column: $table.playerClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentTheme => $composableBuilder(
      column: $table.currentTheme, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarConfig => $composableBuilder(
      column: $table.avatarConfig, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get penaltyBalance => $composableBuilder(
      column: $table.penaltyBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hackerXp => $composableBuilder(
      column: $table.hackerXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get magnateXp => $composableBuilder(
      column: $table.magnateXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resilienceXp => $composableBuilder(
      column: $table.resilienceXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastBonusClaimDate => $composableBuilder(
      column: $table.lastBonusClaimDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bonusStreak => $composableBuilder(
      column: $table.bonusStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get crystalsBalance => $composableBuilder(
      column: $table.crystalsBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get noSpendStreakCount => $composableBuilder(
      column: $table.noSpendStreakCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastNoSpendDate => $composableBuilder(
      column: $table.lastNoSpendDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get karmaDebt => $composableBuilder(
      column: $table.karmaDebt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get debuffActiveUntil => $composableBuilder(
      column: $table.debuffActiveUntil,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partnerName => $composableBuilder(
      column: $table.partnerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get partnerLastDepositDate => $composableBuilder(
      column: $table.partnerLastDepositDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastDiversificationXPDate => $composableBuilder(
      column: $table.lastDiversificationXPDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRebalanceXPDate => $composableBuilder(
      column: $table.lastRebalanceXPDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPricePulseXPDate => $composableBuilder(
      column: $table.lastPricePulseXPDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pricePulseTrackingCount => $composableBuilder(
      column: $table.pricePulseTrackingCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get karmaHealingStreakCount => $composableBuilder(
      column: $table.karmaHealingStreakCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastKarmaHealDate => $composableBuilder(
      column: $table.lastKarmaHealDate,
      builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streakCount => $composableBuilder(
      column: $table.streakCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxStreak => $composableBuilder(
      column: $table.maxStreak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get freezeTokens => $composableBuilder(
      column: $table.freezeTokens,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastDepositDate => $composableBuilder(
      column: $table.lastDepositDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get skillPoints => $composableBuilder(
      column: $table.skillPoints, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerClass => $composableBuilder(
      column: $table.playerClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentTheme => $composableBuilder(
      column: $table.currentTheme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarConfig => $composableBuilder(
      column: $table.avatarConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get penaltyBalance => $composableBuilder(
      column: $table.penaltyBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hackerXp => $composableBuilder(
      column: $table.hackerXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get magnateXp => $composableBuilder(
      column: $table.magnateXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resilienceXp => $composableBuilder(
      column: $table.resilienceXp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastBonusClaimDate => $composableBuilder(
      column: $table.lastBonusClaimDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bonusStreak => $composableBuilder(
      column: $table.bonusStreak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get crystalsBalance => $composableBuilder(
      column: $table.crystalsBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get noSpendStreakCount => $composableBuilder(
      column: $table.noSpendStreakCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastNoSpendDate => $composableBuilder(
      column: $table.lastNoSpendDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get karmaDebt => $composableBuilder(
      column: $table.karmaDebt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get debuffActiveUntil => $composableBuilder(
      column: $table.debuffActiveUntil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partnerName => $composableBuilder(
      column: $table.partnerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get partnerLastDepositDate => $composableBuilder(
      column: $table.partnerLastDepositDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastDiversificationXPDate => $composableBuilder(
      column: $table.lastDiversificationXPDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRebalanceXPDate => $composableBuilder(
      column: $table.lastRebalanceXPDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPricePulseXPDate => $composableBuilder(
      column: $table.lastPricePulseXPDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pricePulseTrackingCount => $composableBuilder(
      column: $table.pricePulseTrackingCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get karmaHealingStreakCount => $composableBuilder(
      column: $table.karmaHealingStreakCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastKarmaHealDate => $composableBuilder(
      column: $table.lastKarmaHealDate,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get streakCount => $composableBuilder(
      column: $table.streakCount, builder: (column) => column);

  GeneratedColumn<int> get maxStreak =>
      $composableBuilder(column: $table.maxStreak, builder: (column) => column);

  GeneratedColumn<int> get freezeTokens => $composableBuilder(
      column: $table.freezeTokens, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDepositDate => $composableBuilder(
      column: $table.lastDepositDate, builder: (column) => column);

  GeneratedColumn<int> get skillPoints => $composableBuilder(
      column: $table.skillPoints, builder: (column) => column);

  GeneratedColumn<String> get playerClass => $composableBuilder(
      column: $table.playerClass, builder: (column) => column);

  GeneratedColumn<String> get currentTheme => $composableBuilder(
      column: $table.currentTheme, builder: (column) => column);

  GeneratedColumn<String> get avatarConfig => $composableBuilder(
      column: $table.avatarConfig, builder: (column) => column);

  GeneratedColumn<int> get penaltyBalance => $composableBuilder(
      column: $table.penaltyBalance, builder: (column) => column);

  GeneratedColumn<int> get hackerXp =>
      $composableBuilder(column: $table.hackerXp, builder: (column) => column);

  GeneratedColumn<int> get magnateXp =>
      $composableBuilder(column: $table.magnateXp, builder: (column) => column);

  GeneratedColumn<int> get resilienceXp => $composableBuilder(
      column: $table.resilienceXp, builder: (column) => column);

  GeneratedColumn<DateTime> get lastBonusClaimDate => $composableBuilder(
      column: $table.lastBonusClaimDate, builder: (column) => column);

  GeneratedColumn<int> get bonusStreak => $composableBuilder(
      column: $table.bonusStreak, builder: (column) => column);

  GeneratedColumn<int> get crystalsBalance => $composableBuilder(
      column: $table.crystalsBalance, builder: (column) => column);

  GeneratedColumn<int> get noSpendStreakCount => $composableBuilder(
      column: $table.noSpendStreakCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastNoSpendDate => $composableBuilder(
      column: $table.lastNoSpendDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get karmaDebt =>
      $composableBuilder(column: $table.karmaDebt, builder: (column) => column);

  GeneratedColumn<DateTime> get debuffActiveUntil => $composableBuilder(
      column: $table.debuffActiveUntil, builder: (column) => column);

  GeneratedColumn<String> get partnerName => $composableBuilder(
      column: $table.partnerName, builder: (column) => column);

  GeneratedColumn<DateTime> get partnerLastDepositDate => $composableBuilder(
      column: $table.partnerLastDepositDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDiversificationXPDate => $composableBuilder(
      column: $table.lastDiversificationXPDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRebalanceXPDate => $composableBuilder(
      column: $table.lastRebalanceXPDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPricePulseXPDate => $composableBuilder(
      column: $table.lastPricePulseXPDate, builder: (column) => column);

  GeneratedColumn<int> get pricePulseTrackingCount => $composableBuilder(
      column: $table.pricePulseTrackingCount, builder: (column) => column);

  GeneratedColumn<int> get karmaHealingStreakCount => $composableBuilder(
      column: $table.karmaHealingStreakCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastKarmaHealDate => $composableBuilder(
      column: $table.lastKarmaHealDate, builder: (column) => column);
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streakCount = const Value.absent(),
            Value<int> maxStreak = const Value.absent(),
            Value<int> freezeTokens = const Value.absent(),
            Value<DateTime?> lastDepositDate = const Value.absent(),
            Value<int> skillPoints = const Value.absent(),
            Value<String?> playerClass = const Value.absent(),
            Value<String> currentTheme = const Value.absent(),
            Value<String?> avatarConfig = const Value.absent(),
            Value<int> penaltyBalance = const Value.absent(),
            Value<int> hackerXp = const Value.absent(),
            Value<int> magnateXp = const Value.absent(),
            Value<int> resilienceXp = const Value.absent(),
            Value<DateTime?> lastBonusClaimDate = const Value.absent(),
            Value<int> bonusStreak = const Value.absent(),
            Value<int> crystalsBalance = const Value.absent(),
            Value<int> noSpendStreakCount = const Value.absent(),
            Value<DateTime?> lastNoSpendDate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> karmaDebt = const Value.absent(),
            Value<DateTime?> debuffActiveUntil = const Value.absent(),
            Value<String?> partnerName = const Value.absent(),
            Value<DateTime?> partnerLastDepositDate = const Value.absent(),
            Value<DateTime?> lastDiversificationXPDate = const Value.absent(),
            Value<DateTime?> lastRebalanceXPDate = const Value.absent(),
            Value<DateTime?> lastPricePulseXPDate = const Value.absent(),
            Value<int> pricePulseTrackingCount = const Value.absent(),
            Value<int> karmaHealingStreakCount = const Value.absent(),
            Value<DateTime?> lastKarmaHealDate = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            xp: xp,
            level: level,
            streakCount: streakCount,
            maxStreak: maxStreak,
            freezeTokens: freezeTokens,
            lastDepositDate: lastDepositDate,
            skillPoints: skillPoints,
            playerClass: playerClass,
            currentTheme: currentTheme,
            avatarConfig: avatarConfig,
            penaltyBalance: penaltyBalance,
            hackerXp: hackerXp,
            magnateXp: magnateXp,
            resilienceXp: resilienceXp,
            lastBonusClaimDate: lastBonusClaimDate,
            bonusStreak: bonusStreak,
            crystalsBalance: crystalsBalance,
            noSpendStreakCount: noSpendStreakCount,
            lastNoSpendDate: lastNoSpendDate,
            updatedAt: updatedAt,
            karmaDebt: karmaDebt,
            debuffActiveUntil: debuffActiveUntil,
            partnerName: partnerName,
            partnerLastDepositDate: partnerLastDepositDate,
            lastDiversificationXPDate: lastDiversificationXPDate,
            lastRebalanceXPDate: lastRebalanceXPDate,
            lastPricePulseXPDate: lastPricePulseXPDate,
            pricePulseTrackingCount: pricePulseTrackingCount,
            karmaHealingStreakCount: karmaHealingStreakCount,
            lastKarmaHealDate: lastKarmaHealDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streakCount = const Value.absent(),
            Value<int> maxStreak = const Value.absent(),
            Value<int> freezeTokens = const Value.absent(),
            Value<DateTime?> lastDepositDate = const Value.absent(),
            Value<int> skillPoints = const Value.absent(),
            Value<String?> playerClass = const Value.absent(),
            Value<String> currentTheme = const Value.absent(),
            Value<String?> avatarConfig = const Value.absent(),
            Value<int> penaltyBalance = const Value.absent(),
            Value<int> hackerXp = const Value.absent(),
            Value<int> magnateXp = const Value.absent(),
            Value<int> resilienceXp = const Value.absent(),
            Value<DateTime?> lastBonusClaimDate = const Value.absent(),
            Value<int> bonusStreak = const Value.absent(),
            Value<int> crystalsBalance = const Value.absent(),
            Value<int> noSpendStreakCount = const Value.absent(),
            Value<DateTime?> lastNoSpendDate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> karmaDebt = const Value.absent(),
            Value<DateTime?> debuffActiveUntil = const Value.absent(),
            Value<String?> partnerName = const Value.absent(),
            Value<DateTime?> partnerLastDepositDate = const Value.absent(),
            Value<DateTime?> lastDiversificationXPDate = const Value.absent(),
            Value<DateTime?> lastRebalanceXPDate = const Value.absent(),
            Value<DateTime?> lastPricePulseXPDate = const Value.absent(),
            Value<int> pricePulseTrackingCount = const Value.absent(),
            Value<int> karmaHealingStreakCount = const Value.absent(),
            Value<DateTime?> lastKarmaHealDate = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            xp: xp,
            level: level,
            streakCount: streakCount,
            maxStreak: maxStreak,
            freezeTokens: freezeTokens,
            lastDepositDate: lastDepositDate,
            skillPoints: skillPoints,
            playerClass: playerClass,
            currentTheme: currentTheme,
            avatarConfig: avatarConfig,
            penaltyBalance: penaltyBalance,
            hackerXp: hackerXp,
            magnateXp: magnateXp,
            resilienceXp: resilienceXp,
            lastBonusClaimDate: lastBonusClaimDate,
            bonusStreak: bonusStreak,
            crystalsBalance: crystalsBalance,
            noSpendStreakCount: noSpendStreakCount,
            lastNoSpendDate: lastNoSpendDate,
            updatedAt: updatedAt,
            karmaDebt: karmaDebt,
            debuffActiveUntil: debuffActiveUntil,
            partnerName: partnerName,
            partnerLastDepositDate: partnerLastDepositDate,
            lastDiversificationXPDate: lastDiversificationXPDate,
            lastRebalanceXPDate: lastRebalanceXPDate,
            lastPricePulseXPDate: lastPricePulseXPDate,
            pricePulseTrackingCount: pricePulseTrackingCount,
            karmaHealingStreakCount: karmaHealingStreakCount,
            lastKarmaHealDate: lastKarmaHealDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()>;
typedef $$UnlockedAchievementsTableCreateCompanionBuilder
    = UnlockedAchievementsCompanion Function({
  required String id,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$UnlockedAchievementsTableUpdateCompanionBuilder
    = UnlockedAchievementsCompanion Function({
  Value<String> id,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

class $$UnlockedAchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementsTable> {
  $$UnlockedAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$UnlockedAchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementsTable> {
  $$UnlockedAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$UnlockedAchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedAchievementsTable> {
  $$UnlockedAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$UnlockedAchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedAchievementsTable,
    UnlockedAchievement,
    $$UnlockedAchievementsTableFilterComposer,
    $$UnlockedAchievementsTableOrderingComposer,
    $$UnlockedAchievementsTableAnnotationComposer,
    $$UnlockedAchievementsTableCreateCompanionBuilder,
    $$UnlockedAchievementsTableUpdateCompanionBuilder,
    (
      UnlockedAchievement,
      BaseReferences<_$AppDatabase, $UnlockedAchievementsTable,
          UnlockedAchievement>
    ),
    UnlockedAchievement,
    PrefetchHooks Function()> {
  $$UnlockedAchievementsTableTableManager(
      _$AppDatabase db, $UnlockedAchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedAchievementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedAchievementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedAchievementsCompanion(
            id: id,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedAchievementsCompanion.insert(
            id: id,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnlockedAchievementsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UnlockedAchievementsTable,
        UnlockedAchievement,
        $$UnlockedAchievementsTableFilterComposer,
        $$UnlockedAchievementsTableOrderingComposer,
        $$UnlockedAchievementsTableAnnotationComposer,
        $$UnlockedAchievementsTableCreateCompanionBuilder,
        $$UnlockedAchievementsTableUpdateCompanionBuilder,
        (
          UnlockedAchievement,
          BaseReferences<_$AppDatabase, $UnlockedAchievementsTable,
              UnlockedAchievement>
        ),
        UnlockedAchievement,
        PrefetchHooks Function()>;
typedef $$UnlockedSkillsTableCreateCompanionBuilder = UnlockedSkillsCompanion
    Function({
  required String id,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$UnlockedSkillsTableUpdateCompanionBuilder = UnlockedSkillsCompanion
    Function({
  Value<String> id,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

class $$UnlockedSkillsTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedSkillsTable> {
  $$UnlockedSkillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$UnlockedSkillsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedSkillsTable> {
  $$UnlockedSkillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$UnlockedSkillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedSkillsTable> {
  $$UnlockedSkillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$UnlockedSkillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedSkillsTable,
    UnlockedSkill,
    $$UnlockedSkillsTableFilterComposer,
    $$UnlockedSkillsTableOrderingComposer,
    $$UnlockedSkillsTableAnnotationComposer,
    $$UnlockedSkillsTableCreateCompanionBuilder,
    $$UnlockedSkillsTableUpdateCompanionBuilder,
    (
      UnlockedSkill,
      BaseReferences<_$AppDatabase, $UnlockedSkillsTable, UnlockedSkill>
    ),
    UnlockedSkill,
    PrefetchHooks Function()> {
  $$UnlockedSkillsTableTableManager(
      _$AppDatabase db, $UnlockedSkillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedSkillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedSkillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedSkillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedSkillsCompanion(
            id: id,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UnlockedSkillsCompanion.insert(
            id: id,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnlockedSkillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnlockedSkillsTable,
    UnlockedSkill,
    $$UnlockedSkillsTableFilterComposer,
    $$UnlockedSkillsTableOrderingComposer,
    $$UnlockedSkillsTableAnnotationComposer,
    $$UnlockedSkillsTableCreateCompanionBuilder,
    $$UnlockedSkillsTableUpdateCompanionBuilder,
    (
      UnlockedSkill,
      BaseReferences<_$AppDatabase, $UnlockedSkillsTable, UnlockedSkill>
    ),
    UnlockedSkill,
    PrefetchHooks Function()>;
typedef $$LootboxesTableCreateCompanionBuilder = LootboxesCompanion Function({
  required String id,
  required String rarity,
  Value<bool> isOpened,
  required DateTime earnedAt,
  Value<int> rowid,
});
typedef $$LootboxesTableUpdateCompanionBuilder = LootboxesCompanion Function({
  Value<String> id,
  Value<String> rarity,
  Value<bool> isOpened,
  Value<DateTime> earnedAt,
  Value<int> rowid,
});

class $$LootboxesTableFilterComposer
    extends Composer<_$AppDatabase, $LootboxesTable> {
  $$LootboxesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOpened => $composableBuilder(
      column: $table.isOpened, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
      column: $table.earnedAt, builder: (column) => ColumnFilters(column));
}

class $$LootboxesTableOrderingComposer
    extends Composer<_$AppDatabase, $LootboxesTable> {
  $$LootboxesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOpened => $composableBuilder(
      column: $table.isOpened, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
      column: $table.earnedAt, builder: (column) => ColumnOrderings(column));
}

class $$LootboxesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LootboxesTable> {
  $$LootboxesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<bool> get isOpened =>
      $composableBuilder(column: $table.isOpened, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);
}

class $$LootboxesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LootboxesTable,
    Lootboxe,
    $$LootboxesTableFilterComposer,
    $$LootboxesTableOrderingComposer,
    $$LootboxesTableAnnotationComposer,
    $$LootboxesTableCreateCompanionBuilder,
    $$LootboxesTableUpdateCompanionBuilder,
    (Lootboxe, BaseReferences<_$AppDatabase, $LootboxesTable, Lootboxe>),
    Lootboxe,
    PrefetchHooks Function()> {
  $$LootboxesTableTableManager(_$AppDatabase db, $LootboxesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LootboxesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LootboxesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LootboxesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> rarity = const Value.absent(),
            Value<bool> isOpened = const Value.absent(),
            Value<DateTime> earnedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LootboxesCompanion(
            id: id,
            rarity: rarity,
            isOpened: isOpened,
            earnedAt: earnedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String rarity,
            Value<bool> isOpened = const Value.absent(),
            required DateTime earnedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LootboxesCompanion.insert(
            id: id,
            rarity: rarity,
            isOpened: isOpened,
            earnedAt: earnedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LootboxesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LootboxesTable,
    Lootboxe,
    $$LootboxesTableFilterComposer,
    $$LootboxesTableOrderingComposer,
    $$LootboxesTableAnnotationComposer,
    $$LootboxesTableCreateCompanionBuilder,
    $$LootboxesTableUpdateCompanionBuilder,
    (Lootboxe, BaseReferences<_$AppDatabase, $LootboxesTable, Lootboxe>),
    Lootboxe,
    PrefetchHooks Function()>;
typedef $$PetsTableCreateCompanionBuilder = PetsCompanion Function({
  required String id,
  required String petType,
  Value<int> happinessLevel,
  required DateTime lastFedAt,
  Value<int> rowid,
});
typedef $$PetsTableUpdateCompanionBuilder = PetsCompanion Function({
  Value<String> id,
  Value<String> petType,
  Value<int> happinessLevel,
  Value<DateTime> lastFedAt,
  Value<int> rowid,
});

class $$PetsTableFilterComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get petType => $composableBuilder(
      column: $table.petType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get happinessLevel => $composableBuilder(
      column: $table.happinessLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastFedAt => $composableBuilder(
      column: $table.lastFedAt, builder: (column) => ColumnFilters(column));
}

class $$PetsTableOrderingComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get petType => $composableBuilder(
      column: $table.petType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get happinessLevel => $composableBuilder(
      column: $table.happinessLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastFedAt => $composableBuilder(
      column: $table.lastFedAt, builder: (column) => ColumnOrderings(column));
}

class $$PetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get petType =>
      $composableBuilder(column: $table.petType, builder: (column) => column);

  GeneratedColumn<int> get happinessLevel => $composableBuilder(
      column: $table.happinessLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFedAt =>
      $composableBuilder(column: $table.lastFedAt, builder: (column) => column);
}

class $$PetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PetsTable,
    Pet,
    $$PetsTableFilterComposer,
    $$PetsTableOrderingComposer,
    $$PetsTableAnnotationComposer,
    $$PetsTableCreateCompanionBuilder,
    $$PetsTableUpdateCompanionBuilder,
    (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
    Pet,
    PrefetchHooks Function()> {
  $$PetsTableTableManager(_$AppDatabase db, $PetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> petType = const Value.absent(),
            Value<int> happinessLevel = const Value.absent(),
            Value<DateTime> lastFedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PetsCompanion(
            id: id,
            petType: petType,
            happinessLevel: happinessLevel,
            lastFedAt: lastFedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String petType,
            Value<int> happinessLevel = const Value.absent(),
            required DateTime lastFedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PetsCompanion.insert(
            id: id,
            petType: petType,
            happinessLevel: happinessLevel,
            lastFedAt: lastFedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PetsTable,
    Pet,
    $$PetsTableFilterComposer,
    $$PetsTableOrderingComposer,
    $$PetsTableAnnotationComposer,
    $$PetsTableCreateCompanionBuilder,
    $$PetsTableUpdateCompanionBuilder,
    (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
    Pet,
    PrefetchHooks Function()>;
typedef $$SquadsTableCreateCompanionBuilder = SquadsCompanion Function({
  required String id,
  required String name,
  Value<int> totalXp,
  Value<int> rowid,
});
typedef $$SquadsTableUpdateCompanionBuilder = SquadsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> totalXp,
  Value<int> rowid,
});

class $$SquadsTableFilterComposer
    extends Composer<_$AppDatabase, $SquadsTable> {
  $$SquadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnFilters(column));
}

class $$SquadsTableOrderingComposer
    extends Composer<_$AppDatabase, $SquadsTable> {
  $$SquadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnOrderings(column));
}

class $$SquadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SquadsTable> {
  $$SquadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);
}

class $$SquadsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SquadsTable,
    Squad,
    $$SquadsTableFilterComposer,
    $$SquadsTableOrderingComposer,
    $$SquadsTableAnnotationComposer,
    $$SquadsTableCreateCompanionBuilder,
    $$SquadsTableUpdateCompanionBuilder,
    (Squad, BaseReferences<_$AppDatabase, $SquadsTable, Squad>),
    Squad,
    PrefetchHooks Function()> {
  $$SquadsTableTableManager(_$AppDatabase db, $SquadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SquadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SquadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SquadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> totalXp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SquadsCompanion(
            id: id,
            name: name,
            totalXp: totalXp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> totalXp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SquadsCompanion.insert(
            id: id,
            name: name,
            totalXp: totalXp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SquadsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SquadsTable,
    Squad,
    $$SquadsTableFilterComposer,
    $$SquadsTableOrderingComposer,
    $$SquadsTableAnnotationComposer,
    $$SquadsTableCreateCompanionBuilder,
    $$SquadsTableUpdateCompanionBuilder,
    (Squad, BaseReferences<_$AppDatabase, $SquadsTable, Squad>),
    Squad,
    PrefetchHooks Function()>;
typedef $$SideQuestsTableCreateCompanionBuilder = SideQuestsCompanion Function({
  required String id,
  required String title,
  required String description,
  Value<bool> isCompleted,
  required DateTime expiresAt,
  Value<int> rowid,
});
typedef $$SideQuestsTableUpdateCompanionBuilder = SideQuestsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<bool> isCompleted,
  Value<DateTime> expiresAt,
  Value<int> rowid,
});

class $$SideQuestsTableFilterComposer
    extends Composer<_$AppDatabase, $SideQuestsTable> {
  $$SideQuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));
}

class $$SideQuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $SideQuestsTable> {
  $$SideQuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));
}

class $$SideQuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SideQuestsTable> {
  $$SideQuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$SideQuestsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SideQuestsTable,
    SideQuest,
    $$SideQuestsTableFilterComposer,
    $$SideQuestsTableOrderingComposer,
    $$SideQuestsTableAnnotationComposer,
    $$SideQuestsTableCreateCompanionBuilder,
    $$SideQuestsTableUpdateCompanionBuilder,
    (SideQuest, BaseReferences<_$AppDatabase, $SideQuestsTable, SideQuest>),
    SideQuest,
    PrefetchHooks Function()> {
  $$SideQuestsTableTableManager(_$AppDatabase db, $SideQuestsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SideQuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SideQuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SideQuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SideQuestsCompanion(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String description,
            Value<bool> isCompleted = const Value.absent(),
            required DateTime expiresAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SideQuestsCompanion.insert(
            id: id,
            title: title,
            description: description,
            isCompleted: isCompleted,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SideQuestsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SideQuestsTable,
    SideQuest,
    $$SideQuestsTableFilterComposer,
    $$SideQuestsTableOrderingComposer,
    $$SideQuestsTableAnnotationComposer,
    $$SideQuestsTableCreateCompanionBuilder,
    $$SideQuestsTableUpdateCompanionBuilder,
    (SideQuest, BaseReferences<_$AppDatabase, $SideQuestsTable, SideQuest>),
    SideQuest,
    PrefetchHooks Function()>;
typedef $$TransactionTagsTableCreateCompanionBuilder = TransactionTagsCompanion
    Function({
  required String id,
  required String depositId,
  required String tag,
  Value<int> rowid,
});
typedef $$TransactionTagsTableUpdateCompanionBuilder = TransactionTagsCompanion
    Function({
  Value<String> id,
  Value<String> depositId,
  Value<String> tag,
  Value<int> rowid,
});

class $$TransactionTagsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depositId => $composableBuilder(
      column: $table.depositId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnFilters(column));
}

class $$TransactionTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depositId => $composableBuilder(
      column: $table.depositId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnOrderings(column));
}

class $$TransactionTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get depositId =>
      $composableBuilder(column: $table.depositId, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$TransactionTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionTagsTable,
    TransactionTag,
    $$TransactionTagsTableFilterComposer,
    $$TransactionTagsTableOrderingComposer,
    $$TransactionTagsTableAnnotationComposer,
    $$TransactionTagsTableCreateCompanionBuilder,
    $$TransactionTagsTableUpdateCompanionBuilder,
    (
      TransactionTag,
      BaseReferences<_$AppDatabase, $TransactionTagsTable, TransactionTag>
    ),
    TransactionTag,
    PrefetchHooks Function()> {
  $$TransactionTagsTableTableManager(
      _$AppDatabase db, $TransactionTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> depositId = const Value.absent(),
            Value<String> tag = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionTagsCompanion(
            id: id,
            depositId: depositId,
            tag: tag,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String depositId,
            required String tag,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionTagsCompanion.insert(
            id: id,
            depositId: depositId,
            tag: tag,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionTagsTable,
    TransactionTag,
    $$TransactionTagsTableFilterComposer,
    $$TransactionTagsTableOrderingComposer,
    $$TransactionTagsTableAnnotationComposer,
    $$TransactionTagsTableCreateCompanionBuilder,
    $$TransactionTagsTableUpdateCompanionBuilder,
    (
      TransactionTag,
      BaseReferences<_$AppDatabase, $TransactionTagsTable, TransactionTag>
    ),
    TransactionTag,
    PrefetchHooks Function()>;
typedef $$VoiceLogsTableCreateCompanionBuilder = VoiceLogsCompanion Function({
  required String id,
  required String depositId,
  required String filePath,
  required DateTime recordedAt,
  Value<int> rowid,
});
typedef $$VoiceLogsTableUpdateCompanionBuilder = VoiceLogsCompanion Function({
  Value<String> id,
  Value<String> depositId,
  Value<String> filePath,
  Value<DateTime> recordedAt,
  Value<int> rowid,
});

class $$VoiceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $VoiceLogsTable> {
  $$VoiceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depositId => $composableBuilder(
      column: $table.depositId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));
}

class $$VoiceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $VoiceLogsTable> {
  $$VoiceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depositId => $composableBuilder(
      column: $table.depositId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));
}

class $$VoiceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoiceLogsTable> {
  $$VoiceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get depositId =>
      $composableBuilder(column: $table.depositId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);
}

class $$VoiceLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VoiceLogsTable,
    VoiceLog,
    $$VoiceLogsTableFilterComposer,
    $$VoiceLogsTableOrderingComposer,
    $$VoiceLogsTableAnnotationComposer,
    $$VoiceLogsTableCreateCompanionBuilder,
    $$VoiceLogsTableUpdateCompanionBuilder,
    (VoiceLog, BaseReferences<_$AppDatabase, $VoiceLogsTable, VoiceLog>),
    VoiceLog,
    PrefetchHooks Function()> {
  $$VoiceLogsTableTableManager(_$AppDatabase db, $VoiceLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoiceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoiceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoiceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> depositId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VoiceLogsCompanion(
            id: id,
            depositId: depositId,
            filePath: filePath,
            recordedAt: recordedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String depositId,
            required String filePath,
            required DateTime recordedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VoiceLogsCompanion.insert(
            id: id,
            depositId: depositId,
            filePath: filePath,
            recordedAt: recordedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VoiceLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VoiceLogsTable,
    VoiceLog,
    $$VoiceLogsTableFilterComposer,
    $$VoiceLogsTableOrderingComposer,
    $$VoiceLogsTableAnnotationComposer,
    $$VoiceLogsTableCreateCompanionBuilder,
    $$VoiceLogsTableUpdateCompanionBuilder,
    (VoiceLog, BaseReferences<_$AppDatabase, $VoiceLogsTable, VoiceLog>),
    VoiceLog,
    PrefetchHooks Function()>;
typedef $$PenaltyHabitsTableCreateCompanionBuilder = PenaltyHabitsCompanion
    Function({
  required String id,
  required String habitName,
  required int penaltyAmount,
  Value<int> rowid,
});
typedef $$PenaltyHabitsTableUpdateCompanionBuilder = PenaltyHabitsCompanion
    Function({
  Value<String> id,
  Value<String> habitName,
  Value<int> penaltyAmount,
  Value<int> rowid,
});

class $$PenaltyHabitsTableFilterComposer
    extends Composer<_$AppDatabase, $PenaltyHabitsTable> {
  $$PenaltyHabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get habitName => $composableBuilder(
      column: $table.habitName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get penaltyAmount => $composableBuilder(
      column: $table.penaltyAmount, builder: (column) => ColumnFilters(column));
}

class $$PenaltyHabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $PenaltyHabitsTable> {
  $$PenaltyHabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get habitName => $composableBuilder(
      column: $table.habitName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get penaltyAmount => $composableBuilder(
      column: $table.penaltyAmount,
      builder: (column) => ColumnOrderings(column));
}

class $$PenaltyHabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PenaltyHabitsTable> {
  $$PenaltyHabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitName =>
      $composableBuilder(column: $table.habitName, builder: (column) => column);

  GeneratedColumn<int> get penaltyAmount => $composableBuilder(
      column: $table.penaltyAmount, builder: (column) => column);
}

class $$PenaltyHabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PenaltyHabitsTable,
    PenaltyHabit,
    $$PenaltyHabitsTableFilterComposer,
    $$PenaltyHabitsTableOrderingComposer,
    $$PenaltyHabitsTableAnnotationComposer,
    $$PenaltyHabitsTableCreateCompanionBuilder,
    $$PenaltyHabitsTableUpdateCompanionBuilder,
    (
      PenaltyHabit,
      BaseReferences<_$AppDatabase, $PenaltyHabitsTable, PenaltyHabit>
    ),
    PenaltyHabit,
    PrefetchHooks Function()> {
  $$PenaltyHabitsTableTableManager(_$AppDatabase db, $PenaltyHabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PenaltyHabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PenaltyHabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PenaltyHabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitName = const Value.absent(),
            Value<int> penaltyAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PenaltyHabitsCompanion(
            id: id,
            habitName: habitName,
            penaltyAmount: penaltyAmount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitName,
            required int penaltyAmount,
            Value<int> rowid = const Value.absent(),
          }) =>
              PenaltyHabitsCompanion.insert(
            id: id,
            habitName: habitName,
            penaltyAmount: penaltyAmount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PenaltyHabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PenaltyHabitsTable,
    PenaltyHabit,
    $$PenaltyHabitsTableFilterComposer,
    $$PenaltyHabitsTableOrderingComposer,
    $$PenaltyHabitsTableAnnotationComposer,
    $$PenaltyHabitsTableCreateCompanionBuilder,
    $$PenaltyHabitsTableUpdateCompanionBuilder,
    (
      PenaltyHabit,
      BaseReferences<_$AppDatabase, $PenaltyHabitsTable, PenaltyHabit>
    ),
    PenaltyHabit,
    PrefetchHooks Function()>;
typedef $$JointGoalsTableCreateCompanionBuilder = JointGoalsCompanion Function({
  required String id,
  required String title,
  required int targetAmount,
  Value<int> currentAmount,
  Value<DateTime?> deadline,
  required DateTime createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$JointGoalsTableUpdateCompanionBuilder = JointGoalsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<int> targetAmount,
  Value<int> currentAmount,
  Value<DateTime?> deadline,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$JointGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $JointGoalsTable> {
  $$JointGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$JointGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $JointGoalsTable> {
  $$JointGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JointGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JointGoalsTable> {
  $$JointGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<int> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JointGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JointGoalsTable,
    JointGoal,
    $$JointGoalsTableFilterComposer,
    $$JointGoalsTableOrderingComposer,
    $$JointGoalsTableAnnotationComposer,
    $$JointGoalsTableCreateCompanionBuilder,
    $$JointGoalsTableUpdateCompanionBuilder,
    (JointGoal, BaseReferences<_$AppDatabase, $JointGoalsTable, JointGoal>),
    JointGoal,
    PrefetchHooks Function()> {
  $$JointGoalsTableTableManager(_$AppDatabase db, $JointGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JointGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JointGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JointGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> targetAmount = const Value.absent(),
            Value<int> currentAmount = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JointGoalsCompanion(
            id: id,
            title: title,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required int targetAmount,
            Value<int> currentAmount = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JointGoalsCompanion.insert(
            id: id,
            title: title,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JointGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JointGoalsTable,
    JointGoal,
    $$JointGoalsTableFilterComposer,
    $$JointGoalsTableOrderingComposer,
    $$JointGoalsTableAnnotationComposer,
    $$JointGoalsTableCreateCompanionBuilder,
    $$JointGoalsTableUpdateCompanionBuilder,
    (JointGoal, BaseReferences<_$AppDatabase, $JointGoalsTable, JointGoal>),
    JointGoal,
    PrefetchHooks Function()>;
typedef $$JointGoalMembersTableCreateCompanionBuilder
    = JointGoalMembersCompanion Function({
  required String id,
  required String goalId,
  required String memberName,
  Value<int> contributedAmount,
  Value<int> avatarIndex,
  Value<bool> isCurrentUser,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$JointGoalMembersTableUpdateCompanionBuilder
    = JointGoalMembersCompanion Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> memberName,
  Value<int> contributedAmount,
  Value<int> avatarIndex,
  Value<bool> isCurrentUser,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$JointGoalMembersTableFilterComposer
    extends Composer<_$AppDatabase, $JointGoalMembersTable> {
  $$JointGoalMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get contributedAmount => $composableBuilder(
      column: $table.contributedAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCurrentUser => $composableBuilder(
      column: $table.isCurrentUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$JointGoalMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $JointGoalMembersTable> {
  $$JointGoalMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contributedAmount => $composableBuilder(
      column: $table.contributedAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCurrentUser => $composableBuilder(
      column: $table.isCurrentUser,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$JointGoalMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $JointGoalMembersTable> {
  $$JointGoalMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get memberName => $composableBuilder(
      column: $table.memberName, builder: (column) => column);

  GeneratedColumn<int> get contributedAmount => $composableBuilder(
      column: $table.contributedAmount, builder: (column) => column);

  GeneratedColumn<int> get avatarIndex => $composableBuilder(
      column: $table.avatarIndex, builder: (column) => column);

  GeneratedColumn<bool> get isCurrentUser => $composableBuilder(
      column: $table.isCurrentUser, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JointGoalMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JointGoalMembersTable,
    JointGoalMember,
    $$JointGoalMembersTableFilterComposer,
    $$JointGoalMembersTableOrderingComposer,
    $$JointGoalMembersTableAnnotationComposer,
    $$JointGoalMembersTableCreateCompanionBuilder,
    $$JointGoalMembersTableUpdateCompanionBuilder,
    (
      JointGoalMember,
      BaseReferences<_$AppDatabase, $JointGoalMembersTable, JointGoalMember>
    ),
    JointGoalMember,
    PrefetchHooks Function()> {
  $$JointGoalMembersTableTableManager(
      _$AppDatabase db, $JointGoalMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JointGoalMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JointGoalMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JointGoalMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<String> memberName = const Value.absent(),
            Value<int> contributedAmount = const Value.absent(),
            Value<int> avatarIndex = const Value.absent(),
            Value<bool> isCurrentUser = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JointGoalMembersCompanion(
            id: id,
            goalId: goalId,
            memberName: memberName,
            contributedAmount: contributedAmount,
            avatarIndex: avatarIndex,
            isCurrentUser: isCurrentUser,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String goalId,
            required String memberName,
            Value<int> contributedAmount = const Value.absent(),
            Value<int> avatarIndex = const Value.absent(),
            Value<bool> isCurrentUser = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JointGoalMembersCompanion.insert(
            id: id,
            goalId: goalId,
            memberName: memberName,
            contributedAmount: contributedAmount,
            avatarIndex: avatarIndex,
            isCurrentUser: isCurrentUser,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JointGoalMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JointGoalMembersTable,
    JointGoalMember,
    $$JointGoalMembersTableFilterComposer,
    $$JointGoalMembersTableOrderingComposer,
    $$JointGoalMembersTableAnnotationComposer,
    $$JointGoalMembersTableCreateCompanionBuilder,
    $$JointGoalMembersTableUpdateCompanionBuilder,
    (
      JointGoalMember,
      BaseReferences<_$AppDatabase, $JointGoalMembersTable, JointGoalMember>
    ),
    JointGoalMember,
    PrefetchHooks Function()>;
typedef $$AvoidedPurchasesTableCreateCompanionBuilder
    = AvoidedPurchasesCompanion Function({
  required String id,
  required String title,
  required int amount,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AvoidedPurchasesTableUpdateCompanionBuilder
    = AvoidedPurchasesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<int> amount,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AvoidedPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $AvoidedPurchasesTable> {
  $$AvoidedPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AvoidedPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $AvoidedPurchasesTable> {
  $$AvoidedPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AvoidedPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvoidedPurchasesTable> {
  $$AvoidedPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AvoidedPurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AvoidedPurchasesTable,
    AvoidedPurchase,
    $$AvoidedPurchasesTableFilterComposer,
    $$AvoidedPurchasesTableOrderingComposer,
    $$AvoidedPurchasesTableAnnotationComposer,
    $$AvoidedPurchasesTableCreateCompanionBuilder,
    $$AvoidedPurchasesTableUpdateCompanionBuilder,
    (
      AvoidedPurchase,
      BaseReferences<_$AppDatabase, $AvoidedPurchasesTable, AvoidedPurchase>
    ),
    AvoidedPurchase,
    PrefetchHooks Function()> {
  $$AvoidedPurchasesTableTableManager(
      _$AppDatabase db, $AvoidedPurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvoidedPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AvoidedPurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AvoidedPurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AvoidedPurchasesCompanion(
            id: id,
            title: title,
            amount: amount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required int amount,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AvoidedPurchasesCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AvoidedPurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AvoidedPurchasesTable,
    AvoidedPurchase,
    $$AvoidedPurchasesTableFilterComposer,
    $$AvoidedPurchasesTableOrderingComposer,
    $$AvoidedPurchasesTableAnnotationComposer,
    $$AvoidedPurchasesTableCreateCompanionBuilder,
    $$AvoidedPurchasesTableUpdateCompanionBuilder,
    (
      AvoidedPurchase,
      BaseReferences<_$AppDatabase, $AvoidedPurchasesTable, AvoidedPurchase>
    ),
    AvoidedPurchase,
    PrefetchHooks Function()>;
typedef $$MemoryVaultEntriesTableCreateCompanionBuilder
    = MemoryVaultEntriesCompanion Function({
  required String id,
  required String goalId,
  required int unlockThresholdPercent,
  Value<String?> content,
  Value<bool> isUnlocked,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$MemoryVaultEntriesTableUpdateCompanionBuilder
    = MemoryVaultEntriesCompanion Function({
  Value<String> id,
  Value<String> goalId,
  Value<int> unlockThresholdPercent,
  Value<String?> content,
  Value<bool> isUnlocked,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MemoryVaultEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryVaultEntriesTable> {
  $$MemoryVaultEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unlockThresholdPercent => $composableBuilder(
      column: $table.unlockThresholdPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MemoryVaultEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryVaultEntriesTable> {
  $$MemoryVaultEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unlockThresholdPercent => $composableBuilder(
      column: $table.unlockThresholdPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MemoryVaultEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryVaultEntriesTable> {
  $$MemoryVaultEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get unlockThresholdPercent => $composableBuilder(
      column: $table.unlockThresholdPercent, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MemoryVaultEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MemoryVaultEntriesTable,
    MemoryVaultEntry,
    $$MemoryVaultEntriesTableFilterComposer,
    $$MemoryVaultEntriesTableOrderingComposer,
    $$MemoryVaultEntriesTableAnnotationComposer,
    $$MemoryVaultEntriesTableCreateCompanionBuilder,
    $$MemoryVaultEntriesTableUpdateCompanionBuilder,
    (
      MemoryVaultEntry,
      BaseReferences<_$AppDatabase, $MemoryVaultEntriesTable, MemoryVaultEntry>
    ),
    MemoryVaultEntry,
    PrefetchHooks Function()> {
  $$MemoryVaultEntriesTableTableManager(
      _$AppDatabase db, $MemoryVaultEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryVaultEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryVaultEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryVaultEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<int> unlockThresholdPercent = const Value.absent(),
            Value<String?> content = const Value.absent(),
            Value<bool> isUnlocked = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryVaultEntriesCompanion(
            id: id,
            goalId: goalId,
            unlockThresholdPercent: unlockThresholdPercent,
            content: content,
            isUnlocked: isUnlocked,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String goalId,
            required int unlockThresholdPercent,
            Value<String?> content = const Value.absent(),
            Value<bool> isUnlocked = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MemoryVaultEntriesCompanion.insert(
            id: id,
            goalId: goalId,
            unlockThresholdPercent: unlockThresholdPercent,
            content: content,
            isUnlocked: isUnlocked,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MemoryVaultEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MemoryVaultEntriesTable,
    MemoryVaultEntry,
    $$MemoryVaultEntriesTableFilterComposer,
    $$MemoryVaultEntriesTableOrderingComposer,
    $$MemoryVaultEntriesTableAnnotationComposer,
    $$MemoryVaultEntriesTableCreateCompanionBuilder,
    $$MemoryVaultEntriesTableUpdateCompanionBuilder,
    (
      MemoryVaultEntry,
      BaseReferences<_$AppDatabase, $MemoryVaultEntriesTable, MemoryVaultEntry>
    ),
    MemoryVaultEntry,
    PrefetchHooks Function()>;
typedef $$LendingContractsTableCreateCompanionBuilder
    = LendingContractsCompanion Function({
  required String id,
  required String debtorName,
  required int amount,
  required DateTime returnDate,
  Value<bool> isReturned,
  required DateTime createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LendingContractsTableUpdateCompanionBuilder
    = LendingContractsCompanion Function({
  Value<String> id,
  Value<String> debtorName,
  Value<int> amount,
  Value<DateTime> returnDate,
  Value<bool> isReturned,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LendingContractsTableFilterComposer
    extends Composer<_$AppDatabase, $LendingContractsTable> {
  $$LendingContractsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get debtorName => $composableBuilder(
      column: $table.debtorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get returnDate => $composableBuilder(
      column: $table.returnDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReturned => $composableBuilder(
      column: $table.isReturned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LendingContractsTableOrderingComposer
    extends Composer<_$AppDatabase, $LendingContractsTable> {
  $$LendingContractsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get debtorName => $composableBuilder(
      column: $table.debtorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get returnDate => $composableBuilder(
      column: $table.returnDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReturned => $composableBuilder(
      column: $table.isReturned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LendingContractsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LendingContractsTable> {
  $$LendingContractsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get debtorName => $composableBuilder(
      column: $table.debtorName, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get returnDate => $composableBuilder(
      column: $table.returnDate, builder: (column) => column);

  GeneratedColumn<bool> get isReturned => $composableBuilder(
      column: $table.isReturned, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LendingContractsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LendingContractsTable,
    LendingContract,
    $$LendingContractsTableFilterComposer,
    $$LendingContractsTableOrderingComposer,
    $$LendingContractsTableAnnotationComposer,
    $$LendingContractsTableCreateCompanionBuilder,
    $$LendingContractsTableUpdateCompanionBuilder,
    (
      LendingContract,
      BaseReferences<_$AppDatabase, $LendingContractsTable, LendingContract>
    ),
    LendingContract,
    PrefetchHooks Function()> {
  $$LendingContractsTableTableManager(
      _$AppDatabase db, $LendingContractsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LendingContractsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LendingContractsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LendingContractsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> debtorName = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<DateTime> returnDate = const Value.absent(),
            Value<bool> isReturned = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LendingContractsCompanion(
            id: id,
            debtorName: debtorName,
            amount: amount,
            returnDate: returnDate,
            isReturned: isReturned,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String debtorName,
            required int amount,
            required DateTime returnDate,
            Value<bool> isReturned = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LendingContractsCompanion.insert(
            id: id,
            debtorName: debtorName,
            amount: amount,
            returnDate: returnDate,
            isReturned: isReturned,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LendingContractsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LendingContractsTable,
    LendingContract,
    $$LendingContractsTableFilterComposer,
    $$LendingContractsTableOrderingComposer,
    $$LendingContractsTableAnnotationComposer,
    $$LendingContractsTableCreateCompanionBuilder,
    $$LendingContractsTableUpdateCompanionBuilder,
    (
      LendingContract,
      BaseReferences<_$AppDatabase, $LendingContractsTable, LendingContract>
    ),
    LendingContract,
    PrefetchHooks Function()>;
typedef $$ChatMessagesTableCreateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<int> id,
  required String role,
  required String content,
  Value<DateTime> createdAt,
});
typedef $$ChatMessagesTableUpdateCompanionBuilder = ChatMessagesCompanion
    Function({
  Value<int> id,
  Value<String> role,
  Value<String> content,
  Value<DateTime> createdAt,
});

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessage,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>
    ),
    ChatMessage,
    PrefetchHooks Function()> {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChatMessagesCompanion(
            id: id,
            role: role,
            content: content,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String role,
            required String content,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChatMessagesCompanion.insert(
            id: id,
            role: role,
            content: content,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTable,
    ChatMessage,
    $$ChatMessagesTableFilterComposer,
    $$ChatMessagesTableOrderingComposer,
    $$ChatMessagesTableAnnotationComposer,
    $$ChatMessagesTableCreateCompanionBuilder,
    $$ChatMessagesTableUpdateCompanionBuilder,
    (
      ChatMessage,
      BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>
    ),
    ChatMessage,
    PrefetchHooks Function()>;
typedef $$InvestmentPortfolioTableCreateCompanionBuilder
    = InvestmentPortfolioCompanion Function({
  required String assetId,
  required String assetName,
  required int amountOwned,
  required double averageBuyPrice,
  Value<int> rowid,
});
typedef $$InvestmentPortfolioTableUpdateCompanionBuilder
    = InvestmentPortfolioCompanion Function({
  Value<String> assetId,
  Value<String> assetName,
  Value<int> amountOwned,
  Value<double> averageBuyPrice,
  Value<int> rowid,
});

class $$InvestmentPortfolioTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentPortfolioTable> {
  $$InvestmentPortfolioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get assetId => $composableBuilder(
      column: $table.assetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetName => $composableBuilder(
      column: $table.assetName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountOwned => $composableBuilder(
      column: $table.amountOwned, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get averageBuyPrice => $composableBuilder(
      column: $table.averageBuyPrice,
      builder: (column) => ColumnFilters(column));
}

class $$InvestmentPortfolioTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentPortfolioTable> {
  $$InvestmentPortfolioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get assetId => $composableBuilder(
      column: $table.assetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetName => $composableBuilder(
      column: $table.assetName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountOwned => $composableBuilder(
      column: $table.amountOwned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get averageBuyPrice => $composableBuilder(
      column: $table.averageBuyPrice,
      builder: (column) => ColumnOrderings(column));
}

class $$InvestmentPortfolioTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentPortfolioTable> {
  $$InvestmentPortfolioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get assetName =>
      $composableBuilder(column: $table.assetName, builder: (column) => column);

  GeneratedColumn<int> get amountOwned => $composableBuilder(
      column: $table.amountOwned, builder: (column) => column);

  GeneratedColumn<double> get averageBuyPrice => $composableBuilder(
      column: $table.averageBuyPrice, builder: (column) => column);
}

class $$InvestmentPortfolioTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentPortfolioTable,
    InvestmentPortfolioData,
    $$InvestmentPortfolioTableFilterComposer,
    $$InvestmentPortfolioTableOrderingComposer,
    $$InvestmentPortfolioTableAnnotationComposer,
    $$InvestmentPortfolioTableCreateCompanionBuilder,
    $$InvestmentPortfolioTableUpdateCompanionBuilder,
    (
      InvestmentPortfolioData,
      BaseReferences<_$AppDatabase, $InvestmentPortfolioTable,
          InvestmentPortfolioData>
    ),
    InvestmentPortfolioData,
    PrefetchHooks Function()> {
  $$InvestmentPortfolioTableTableManager(
      _$AppDatabase db, $InvestmentPortfolioTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentPortfolioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentPortfolioTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentPortfolioTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> assetId = const Value.absent(),
            Value<String> assetName = const Value.absent(),
            Value<int> amountOwned = const Value.absent(),
            Value<double> averageBuyPrice = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentPortfolioCompanion(
            assetId: assetId,
            assetName: assetName,
            amountOwned: amountOwned,
            averageBuyPrice: averageBuyPrice,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String assetId,
            required String assetName,
            required int amountOwned,
            required double averageBuyPrice,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentPortfolioCompanion.insert(
            assetId: assetId,
            assetName: assetName,
            amountOwned: amountOwned,
            averageBuyPrice: averageBuyPrice,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InvestmentPortfolioTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvestmentPortfolioTable,
    InvestmentPortfolioData,
    $$InvestmentPortfolioTableFilterComposer,
    $$InvestmentPortfolioTableOrderingComposer,
    $$InvestmentPortfolioTableAnnotationComposer,
    $$InvestmentPortfolioTableCreateCompanionBuilder,
    $$InvestmentPortfolioTableUpdateCompanionBuilder,
    (
      InvestmentPortfolioData,
      BaseReferences<_$AppDatabase, $InvestmentPortfolioTable,
          InvestmentPortfolioData>
    ),
    InvestmentPortfolioData,
    PrefetchHooks Function()>;
typedef $$MarketPricesTableCreateCompanionBuilder = MarketPricesCompanion
    Function({
  required String symbol,
  required double price,
  required String currency,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MarketPricesTableUpdateCompanionBuilder = MarketPricesCompanion
    Function({
  Value<String> symbol,
  Value<double> price,
  Value<String> currency,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MarketPricesTableFilterComposer
    extends Composer<_$AppDatabase, $MarketPricesTable> {
  $$MarketPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MarketPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $MarketPricesTable> {
  $$MarketPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MarketPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarketPricesTable> {
  $$MarketPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MarketPricesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MarketPricesTable,
    MarketPrice,
    $$MarketPricesTableFilterComposer,
    $$MarketPricesTableOrderingComposer,
    $$MarketPricesTableAnnotationComposer,
    $$MarketPricesTableCreateCompanionBuilder,
    $$MarketPricesTableUpdateCompanionBuilder,
    (
      MarketPrice,
      BaseReferences<_$AppDatabase, $MarketPricesTable, MarketPrice>
    ),
    MarketPrice,
    PrefetchHooks Function()> {
  $$MarketPricesTableTableManager(_$AppDatabase db, $MarketPricesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> symbol = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MarketPricesCompanion(
            symbol: symbol,
            price: price,
            currency: currency,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String symbol,
            required double price,
            required String currency,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MarketPricesCompanion.insert(
            symbol: symbol,
            price: price,
            currency: currency,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MarketPricesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MarketPricesTable,
    MarketPrice,
    $$MarketPricesTableFilterComposer,
    $$MarketPricesTableOrderingComposer,
    $$MarketPricesTableAnnotationComposer,
    $$MarketPricesTableCreateCompanionBuilder,
    $$MarketPricesTableUpdateCompanionBuilder,
    (
      MarketPrice,
      BaseReferences<_$AppDatabase, $MarketPricesTable, MarketPrice>
    ),
    MarketPrice,
    PrefetchHooks Function()>;
typedef $$PriceHistoryEntriesTableCreateCompanionBuilder
    = PriceHistoryEntriesCompanion Function({
  Value<int> id,
  required String goalId,
  required int priceKopecks,
  Value<String> store,
  Value<String> dataSource,
  required DateTime cachedAt,
});
typedef $$PriceHistoryEntriesTableUpdateCompanionBuilder
    = PriceHistoryEntriesCompanion Function({
  Value<int> id,
  Value<String> goalId,
  Value<int> priceKopecks,
  Value<String> store,
  Value<String> dataSource,
  Value<DateTime> cachedAt,
});

class $$PriceHistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PriceHistoryEntriesTable> {
  $$PriceHistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceKopecks => $composableBuilder(
      column: $table.priceKopecks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get store => $composableBuilder(
      column: $table.store, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$PriceHistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceHistoryEntriesTable> {
  $$PriceHistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceKopecks => $composableBuilder(
      column: $table.priceKopecks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get store => $composableBuilder(
      column: $table.store, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$PriceHistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceHistoryEntriesTable> {
  $$PriceHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get priceKopecks => $composableBuilder(
      column: $table.priceKopecks, builder: (column) => column);

  GeneratedColumn<String> get store =>
      $composableBuilder(column: $table.store, builder: (column) => column);

  GeneratedColumn<String> get dataSource => $composableBuilder(
      column: $table.dataSource, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PriceHistoryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PriceHistoryEntriesTable,
    PriceHistoryEntry,
    $$PriceHistoryEntriesTableFilterComposer,
    $$PriceHistoryEntriesTableOrderingComposer,
    $$PriceHistoryEntriesTableAnnotationComposer,
    $$PriceHistoryEntriesTableCreateCompanionBuilder,
    $$PriceHistoryEntriesTableUpdateCompanionBuilder,
    (
      PriceHistoryEntry,
      BaseReferences<_$AppDatabase, $PriceHistoryEntriesTable,
          PriceHistoryEntry>
    ),
    PriceHistoryEntry,
    PrefetchHooks Function()> {
  $$PriceHistoryEntriesTableTableManager(
      _$AppDatabase db, $PriceHistoryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceHistoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceHistoryEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceHistoryEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<int> priceKopecks = const Value.absent(),
            Value<String> store = const Value.absent(),
            Value<String> dataSource = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
          }) =>
              PriceHistoryEntriesCompanion(
            id: id,
            goalId: goalId,
            priceKopecks: priceKopecks,
            store: store,
            dataSource: dataSource,
            cachedAt: cachedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String goalId,
            required int priceKopecks,
            Value<String> store = const Value.absent(),
            Value<String> dataSource = const Value.absent(),
            required DateTime cachedAt,
          }) =>
              PriceHistoryEntriesCompanion.insert(
            id: id,
            goalId: goalId,
            priceKopecks: priceKopecks,
            store: store,
            dataSource: dataSource,
            cachedAt: cachedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PriceHistoryEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PriceHistoryEntriesTable,
    PriceHistoryEntry,
    $$PriceHistoryEntriesTableFilterComposer,
    $$PriceHistoryEntriesTableOrderingComposer,
    $$PriceHistoryEntriesTableAnnotationComposer,
    $$PriceHistoryEntriesTableCreateCompanionBuilder,
    $$PriceHistoryEntriesTableUpdateCompanionBuilder,
    (
      PriceHistoryEntry,
      BaseReferences<_$AppDatabase, $PriceHistoryEntriesTable,
          PriceHistoryEntry>
    ),
    PriceHistoryEntry,
    PrefetchHooks Function()>;
typedef $$SubscriptionsTableCreateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  required String name,
  required int amountKopecks,
  Value<String> currency,
  Value<String> billingCycle,
  required DateTime nextBillingDate,
  Value<int> reminderDaysBefore,
  Value<bool> isActive,
  Value<DateTime> lastCheckedAt,
  Value<DateTime> createdAt,
});
typedef $$SubscriptionsTableUpdateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> amountKopecks,
  Value<String> currency,
  Value<String> billingCycle,
  Value<DateTime> nextBillingDate,
  Value<int> reminderDaysBefore,
  Value<bool> isActive,
  Value<DateTime> lastCheckedAt,
  Value<DateTime> createdAt,
});

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountKopecks => $composableBuilder(
      column: $table.amountKopecks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
      column: $table.nextBillingDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderDaysBefore => $composableBuilder(
      column: $table.reminderDaysBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountKopecks => $composableBuilder(
      column: $table.amountKopecks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
      column: $table.nextBillingDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderDaysBefore => $composableBuilder(
      column: $table.reminderDaysBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountKopecks => $composableBuilder(
      column: $table.amountKopecks, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => column);

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
      column: $table.nextBillingDate, builder: (column) => column);

  GeneratedColumn<int> get reminderDaysBefore => $composableBuilder(
      column: $table.reminderDaysBefore, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCheckedAt => $composableBuilder(
      column: $table.lastCheckedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SubscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      Subscription,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>
    ),
    Subscription,
    PrefetchHooks Function()> {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> amountKopecks = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> billingCycle = const Value.absent(),
            Value<DateTime> nextBillingDate = const Value.absent(),
            Value<int> reminderDaysBefore = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> lastCheckedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SubscriptionsCompanion(
            id: id,
            name: name,
            amountKopecks: amountKopecks,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            reminderDaysBefore: reminderDaysBefore,
            isActive: isActive,
            lastCheckedAt: lastCheckedAt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int amountKopecks,
            Value<String> currency = const Value.absent(),
            Value<String> billingCycle = const Value.absent(),
            required DateTime nextBillingDate,
            Value<int> reminderDaysBefore = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> lastCheckedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SubscriptionsCompanion.insert(
            id: id,
            name: name,
            amountKopecks: amountKopecks,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            reminderDaysBefore: reminderDaysBefore,
            isActive: isActive,
            lastCheckedAt: lastCheckedAt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      Subscription,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>
    ),
    Subscription,
    PrefetchHooks Function()>;
typedef $$GiftGoalsTableCreateCompanionBuilder = GiftGoalsCompanion Function({
  required String id,
  required String goalId,
  required String recipientName,
  required String recipientRelationship,
  required String occasionType,
  required DateTime occasionDate,
  Value<String> emoji,
  Value<String?> personalizedMessage,
  Value<bool> isSurpriseMode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$GiftGoalsTableUpdateCompanionBuilder = GiftGoalsCompanion Function({
  Value<String> id,
  Value<String> goalId,
  Value<String> recipientName,
  Value<String> recipientRelationship,
  Value<String> occasionType,
  Value<DateTime> occasionDate,
  Value<String> emoji,
  Value<String?> personalizedMessage,
  Value<bool> isSurpriseMode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$GiftGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $GiftGoalsTable> {
  $$GiftGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientName => $composableBuilder(
      column: $table.recipientName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientRelationship => $composableBuilder(
      column: $table.recipientRelationship,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get occasionType => $composableBuilder(
      column: $table.occasionType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occasionDate => $composableBuilder(
      column: $table.occasionDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personalizedMessage => $composableBuilder(
      column: $table.personalizedMessage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSurpriseMode => $composableBuilder(
      column: $table.isSurpriseMode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$GiftGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GiftGoalsTable> {
  $$GiftGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalId => $composableBuilder(
      column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientName => $composableBuilder(
      column: $table.recipientName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientRelationship => $composableBuilder(
      column: $table.recipientRelationship,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get occasionType => $composableBuilder(
      column: $table.occasionType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occasionDate => $composableBuilder(
      column: $table.occasionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personalizedMessage => $composableBuilder(
      column: $table.personalizedMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSurpriseMode => $composableBuilder(
      column: $table.isSurpriseMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$GiftGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GiftGoalsTable> {
  $$GiftGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get recipientName => $composableBuilder(
      column: $table.recipientName, builder: (column) => column);

  GeneratedColumn<String> get recipientRelationship => $composableBuilder(
      column: $table.recipientRelationship, builder: (column) => column);

  GeneratedColumn<String> get occasionType => $composableBuilder(
      column: $table.occasionType, builder: (column) => column);

  GeneratedColumn<DateTime> get occasionDate => $composableBuilder(
      column: $table.occasionDate, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get personalizedMessage => $composableBuilder(
      column: $table.personalizedMessage, builder: (column) => column);

  GeneratedColumn<bool> get isSurpriseMode => $composableBuilder(
      column: $table.isSurpriseMode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GiftGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GiftGoalsTable,
    GiftGoal,
    $$GiftGoalsTableFilterComposer,
    $$GiftGoalsTableOrderingComposer,
    $$GiftGoalsTableAnnotationComposer,
    $$GiftGoalsTableCreateCompanionBuilder,
    $$GiftGoalsTableUpdateCompanionBuilder,
    (GiftGoal, BaseReferences<_$AppDatabase, $GiftGoalsTable, GiftGoal>),
    GiftGoal,
    PrefetchHooks Function()> {
  $$GiftGoalsTableTableManager(_$AppDatabase db, $GiftGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GiftGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GiftGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GiftGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> goalId = const Value.absent(),
            Value<String> recipientName = const Value.absent(),
            Value<String> recipientRelationship = const Value.absent(),
            Value<String> occasionType = const Value.absent(),
            Value<DateTime> occasionDate = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String?> personalizedMessage = const Value.absent(),
            Value<bool> isSurpriseMode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GiftGoalsCompanion(
            id: id,
            goalId: goalId,
            recipientName: recipientName,
            recipientRelationship: recipientRelationship,
            occasionType: occasionType,
            occasionDate: occasionDate,
            emoji: emoji,
            personalizedMessage: personalizedMessage,
            isSurpriseMode: isSurpriseMode,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String goalId,
            required String recipientName,
            required String recipientRelationship,
            required String occasionType,
            required DateTime occasionDate,
            Value<String> emoji = const Value.absent(),
            Value<String?> personalizedMessage = const Value.absent(),
            Value<bool> isSurpriseMode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GiftGoalsCompanion.insert(
            id: id,
            goalId: goalId,
            recipientName: recipientName,
            recipientRelationship: recipientRelationship,
            occasionType: occasionType,
            occasionDate: occasionDate,
            emoji: emoji,
            personalizedMessage: personalizedMessage,
            isSurpriseMode: isSurpriseMode,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GiftGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GiftGoalsTable,
    GiftGoal,
    $$GiftGoalsTableFilterComposer,
    $$GiftGoalsTableOrderingComposer,
    $$GiftGoalsTableAnnotationComposer,
    $$GiftGoalsTableCreateCompanionBuilder,
    $$GiftGoalsTableUpdateCompanionBuilder,
    (GiftGoal, BaseReferences<_$AppDatabase, $GiftGoalsTable, GiftGoal>),
    GiftGoal,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$DepositsTableTableManager get deposits =>
      $$DepositsTableTableManager(_db, _db.deposits);
  $$DepositAllocationsTableTableManager get depositAllocations =>
      $$DepositAllocationsTableTableManager(_db, _db.depositAllocations);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$UnlockedAchievementsTableTableManager get unlockedAchievements =>
      $$UnlockedAchievementsTableTableManager(_db, _db.unlockedAchievements);
  $$UnlockedSkillsTableTableManager get unlockedSkills =>
      $$UnlockedSkillsTableTableManager(_db, _db.unlockedSkills);
  $$LootboxesTableTableManager get lootboxes =>
      $$LootboxesTableTableManager(_db, _db.lootboxes);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$SquadsTableTableManager get squads =>
      $$SquadsTableTableManager(_db, _db.squads);
  $$SideQuestsTableTableManager get sideQuests =>
      $$SideQuestsTableTableManager(_db, _db.sideQuests);
  $$TransactionTagsTableTableManager get transactionTags =>
      $$TransactionTagsTableTableManager(_db, _db.transactionTags);
  $$VoiceLogsTableTableManager get voiceLogs =>
      $$VoiceLogsTableTableManager(_db, _db.voiceLogs);
  $$PenaltyHabitsTableTableManager get penaltyHabits =>
      $$PenaltyHabitsTableTableManager(_db, _db.penaltyHabits);
  $$JointGoalsTableTableManager get jointGoals =>
      $$JointGoalsTableTableManager(_db, _db.jointGoals);
  $$JointGoalMembersTableTableManager get jointGoalMembers =>
      $$JointGoalMembersTableTableManager(_db, _db.jointGoalMembers);
  $$AvoidedPurchasesTableTableManager get avoidedPurchases =>
      $$AvoidedPurchasesTableTableManager(_db, _db.avoidedPurchases);
  $$MemoryVaultEntriesTableTableManager get memoryVaultEntries =>
      $$MemoryVaultEntriesTableTableManager(_db, _db.memoryVaultEntries);
  $$LendingContractsTableTableManager get lendingContracts =>
      $$LendingContractsTableTableManager(_db, _db.lendingContracts);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$InvestmentPortfolioTableTableManager get investmentPortfolio =>
      $$InvestmentPortfolioTableTableManager(_db, _db.investmentPortfolio);
  $$MarketPricesTableTableManager get marketPrices =>
      $$MarketPricesTableTableManager(_db, _db.marketPrices);
  $$PriceHistoryEntriesTableTableManager get priceHistoryEntries =>
      $$PriceHistoryEntriesTableTableManager(_db, _db.priceHistoryEntries);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$GiftGoalsTableTableManager get giftGoals =>
      $$GiftGoalsTableTableManager(_db, _db.giftGoals);
}
