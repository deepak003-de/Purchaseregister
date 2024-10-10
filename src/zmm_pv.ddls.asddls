@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZMM_PV
  provider contract transactional_query
  as projection on ZMM_NPR

{
  key GLNumber,
  key GLItem,
  key GRYear,
   PurchaseOrder,
      CompanyCode,
      PurchaseOrderItem,
      MaterialType,
      MaterialTypeName,
      Material,
      MaterialDescription,
      @Semantics.amount.currencyCode:       'POCurrency'
      Baseprice,
      Baseunit,
      POCurrency,
      FXRate,
      HSNCode,
      plant,
      PlantState,
      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      POQuantity,
      StorageLocation,
      Materialgroup,
      MaterialgroupName,
      PurchaseGroup,
      PurchasingGroupName,
      PurchaseTaxcode,
      PurchaseOrderDate,
      PurchaseOrderType,
      PurchaseOrderTypeName,
      DeliveryYear,
      GRDocument,
      GRDocumentitem,
      PostingDate,
      DebitCreditCode,
      MovementType,
      GRDeliveryNote,
      DeliveryDate,
      @Semantics.quantity.unitOfMeasure:    'EntryUnit'
      QuantityInEntryUnit,
      EntryUnit,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      TotalGoodsMvtAmtInCCCrcy,
      CompanyCodeCurrency,
      GLAccount,
      GLAccountName,
      SupplierInvoiceNo,
      SupplierInvoiceItem,
      FiscalYear,
      InvoiceDate,
      InvoicePostingDate,
      InvoiceReference,
      Supplierinvoicedebitcreditcode,
      Taxcodee,
//      TaxDescription,
//      TaxRate,
      //      GRDocument,
      //      GRPostingDate,
      //      SupplierInvoiceNo,
//      SupplierInvoiceDate,
//      VendorName,
//      //      MaterialDescription,
      hsnno,
      Country,
      pricebasic,
      //      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      //      quantity,
      //      Baseunit,
      @Semantics.amount.currencyCode:       'PriceUnit'
      Rate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      taxablevalue,
      PriceUnit,
      discountvalue,
      @Semantics.amount.currencyCode:       'PriceUnit'
      cgstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      sgstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      igstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      grossamount,
      @Semantics.quantity.unitOfMeasure:    'InvoiceUnit'
      InvoiceQuantity,
      InvoiceUnit,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      InvoiceAmount,
      @Semantics.amount.currencyCode:       'SupplierInvoiceCurrencyCode'
      Amountinlocalcurrency,
      SupplierInvoiceCurrencyCode,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency1'
      AmountInCompanyCodeCurrency,
      CompanyCodeCurrency1,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      TDSAmount,
      TDSRate,
      NetPayable,
      Vendor,
      Ctn,
      Language,
      Region,
      VendorStateName,
      VenName,
      VendorStatecode,
      SupplierGSTNumber,
      SupplierPANNumber
}
