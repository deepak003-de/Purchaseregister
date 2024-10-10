@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Root Entity'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZMM_NPR
  as select from     I_JournalEntry                as JEH
    inner join       I_JournalEntryItem            as JEI      on  JEI.AccountingDocument =  JEH.AccountingDocument
                                                               and JEI.FiscalYear         =  JEH.FiscalYear
                                                               and JEI.Ledger             =  '2L'
                                                               and JEI.LedgerGLLineItem   =  '000001'
//                                                               and JEI.TaxCode            <> ''
    left outer join  I_Supplier                    as Supplier on Supplier.Supplier = JEI.Supplier
    left outer join  I_RegionText                  as Text     on  Text.Country  = Supplier.Country
                                                               and Text.Region   = Supplier.Region
                                                               and Text.Language = 'E'
    right outer join I_OperationalAcctgDocItem     as ACI   on  ACI.AccountingDocument =  JEI.AccountingDocument
                                                               and ACI.FiscalYear         =  JEI.FiscalYear
                                                              and ACI.ProfitCenter       <> ''
  //  inner join I_OperationalAcctgDocItem     as ACI   on  ACI.AccountingDocument =  JEI.AccountingDocument
   //                                                            and ACI.FiscalYear         =  JEI.FiscalYear
    //                                                           and ACI.ProfitCenter       <> ''
    left outer join  I_PurchaseOrderItemAPI01      as POI      on  POI.PurchaseOrder     = ACI.PurchasingDocument
                                                               and POI.PurchaseOrderItem = ACI.PurchasingDocumentItem
    left outer join  I_PurchaseOrderAPI01          as POH      on POH.PurchaseOrder = ACI.PurchasingDocument
   left outer join ZMM_RE                         as MDI      on  MDI.PurchaseOrder     = POI.PurchaseOrder                                                                    
                                                              and MDI.PurchaseOrderItem = POI.PurchaseOrderItem
    //left outer join  I_JournalEntryItem            as AICCC    on  AICCC.ReferenceDocument = MDI.SupplierInvoiceNo
     //                                                          and AICCC.Ledger            = '0L'
     //                                                          and AICCC.LedgerGLLineItem  = '000001'
   left outer join  I_JournalEntryItem            as TDS      on  TDS.ReferenceDocument            = MDI.SupplierInvoiceNo
                                                               and TDS.FiscalYear                   = MDI.FiscalYear
                                                               and TDS.CompanyCode                  = MDI.CompanyCode
                                                            and TDS.Ledger                       = '0L'
                                                               and TDS.TransactionTypeDetermination = 'WIT'
   left outer join  I_GLAccountText               as TDSText  on  TDSText.GLAccount = TDS.GLAccount
//                                                               and TDSText.Language  = 'E'
    left outer join  I_ProductGroupText_2          as PGDesc   on PGDesc.ProductGroup = POI.MaterialGroup
    left outer join  I_ProductTypeText             as MTDesc   on MTDesc.ProductType = POI.MaterialType
    left outer join  I_PurchasingGroup             as PUGDesc  on PUGDesc.PurchasingGroup = POH.PurchasingGroup
    left outer join  I_PurchasingDocumentTypeText  as POTT     on  POTT.PurchasingDocumentType     = POH.PurchaseOrderType
                                                               and POTT.PurchasingDocumentCategory = POI.PurchaseOrderCategory
                                                               and POTT.Language                   = 'E'
    left outer join  I_ProductText                 as PRT      on  PRT.Product  = ACI.Product
                                                               and PRT.Language = 'E'
    left outer join  I_GLAccountText               as GLT      on  GLT.GLAccount = ACI.GLAccount
                                                               and GLT.Language  = 'E'
    left outer join  I_OperationalAcctgDocItem     as CGST     on  CGST.AccountingDocument           = ACI.AccountingDocument
                                                               and CGST.FiscalYear                   = ACI.FiscalYear
                                                               and CGST.TaxItemGroup                 = ACI.TaxItemGroup
                                                               and CGST.AccountingDocumentItemType   = 'T'
                                                               and CGST.TransactionTypeDetermination = 'JIC'
    left outer join  I_OperationalAcctgDocItem     as IGST     on  IGST.AccountingDocument           = ACI.AccountingDocument
                                                               and IGST.FiscalYear                   = ACI.FiscalYear
                                                               and IGST.TaxItemGroup                 = ACI.TaxItemGroup
                                                               and IGST.AccountingDocumentItemType   = 'T'
                                                               and IGST.TransactionTypeDetermination = 'JII' // or JIM
    left outer join  ztaxcodetb                    as TAX      on TAX.taxcode = MDI.Taxcodee

{
  key ACI.AccountingDocument                as GLNumber,
  key ACI.AccountingDocumentItem            as GLItem,
  key ACI.FiscalYear                        as GRYear,
   POH.PurchaseOrder                     as PurchaseOrder,
      POH.CompanyCode                       as CompanyCode,
      POI.PurchaseOrderItem                 as PurchaseOrderItem,
      POI.MaterialType                      as MaterialType,
      MTDesc.MaterialTypeName               as MaterialTypeName,
      POI.Material                          as Material,
      POI.PurchaseOrderItemText             as MaterialDescription,
      @Semantics.amount.currencyCode:       'POCurrency'
      POI.NetPriceAmount                    as Baseprice,
      POI.PurchaseOrderQuantityUnit         as Baseunit,
      POI.DocumentCurrency                  as POCurrency,
      POH.ExchangeRate                      as FXRate,
      POI.BR_NCM                            as HSNCode,
      POI.Plant                             as plant,
      POI.YY1_Plant_State_Name_PDI          as PlantState,
      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      POI.OrderQuantity                     as POQuantity,
      POI.StorageLocation                   as StorageLocation,
      POI.MaterialGroup                     as Materialgroup,
      PGDesc.ProductGroupName               as MaterialgroupName,
      POH.PurchasingGroup                   as PurchaseGroup,
      PUGDesc.PurchasingGroupName           as PurchasingGroupName,
      POI.TaxCode                           as PurchaseTaxcode,
      POH.PurchaseOrderDate                 as PurchaseOrderDate,
      POH.PurchaseOrderType                 as PurchaseOrderType,
      POTT.PurchasingDocumentTypeName       as PurchaseOrderTypeName,
 //     MDI.MaterialDocumentYear              as DeliveryYear,
      MDI.MaterialDocument                  as GRDocument,
      MDI.MaterialDocumentItem              as GRDocumentitem,
      MDI.MaterialDocumentYear    as  DeliveryYear,
      MDI.PostingDate                       as PostingDate,
      MDI.DebitCreditCode                   as DebitCreditCode,
      MDI.GoodsMovementType                 as MovementType,
      MDI.ReferenceDocument                 as GRDeliveryNote,
      MDI.DocumentDate                      as DeliveryDate,
      @Semantics.quantity.unitOfMeasure:    'EntryUnit'
      MDI.QuantityInEntryUnit,
      MDI.EntryUnit,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      MDI.TotalGoodsMvtAmtInCCCrcy,
      MDI.CompanyCodeCurrency,
      ACI.GLAccount,
      GLT.GLAccountName,
      MDI.SupplierInvoiceNo,
      MDI.SupplierInvoiceItem           as SupplierInvoiceItem,
      MDI.FiscalYear                    as FiscalYear,
      MDI.DocumentDate                  as InvoiceDate,
      MDI.PostingDate                   as InvoicePostingDate,
      MDI.InvoiceReference,
      MDI.DebitCreditCode               as Supplierinvoicedebitcreditcode,
      MDI.Taxcodee,
      TAX.taxtype                           as TaxDescription,
      TAX.taxate                            as TaxRate,
      //      substring(ACI.Reference3IDByBusinessPartner,5,10) as GRDocument, //5 is place, !0 is length
      ACI.PostingDate                       as GRPostingDate,
      //      substring(ACI.OriginalReferenceDocument,1,10) as SupplierInvoiceNo,
      ACI.PostingDate                       as SupplierInvoiceDate,
      Supplier.SupplierName                 as VendorName,
      //      abap.string'' as acchead,
      //      SIH.SupplierInvoiceIDByInvcgParty as narration,
      //      PRT.ProductName                                   as MaterialDescription,
      ACI.IN_HSNOrSACCode                   as hsnno,
      POH.IncotermsTransferLocation         as Country,
      POH.IncotermsClassification           as pricebasic,
      //      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      //      ACI.Quantity                                      as quantity,
      //      ACI.BaseUnit                                      as Baseunit,
      @Semantics.amount.currencyCode:       'PriceUnit'
      case
       when ACI.AmountInTransactionCurrency is not initial and ACI.Quantity is not initial
       then cast( get_numeric_value(ACI.AmountInTransactionCurrency) / get_numeric_value(ACI.Quantity) as abap.dec( 12, 2 ) )
       else null end                        as Rate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      ACI.AmountInTransactionCurrency       as taxablevalue,
      ACI.TransactionCurrency               as PriceUnit,
      // @Semantics.amount.currencyCode:       'PriceUnit'
      abap.string''                         as discountvalue,
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency      as cgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency      as sgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      IGST.AmountInTransactionCurrency      as igstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      case
      when CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JIS'
      then CGST.AmountInTransactionCurrency + CGST.AmountInTransactionCurrency
      when IGST.TransactionTypeDetermination = 'JII'
      then IGST.AmountInTransactionCurrency
      end                                   as grossamount,
      @Semantics.quantity.unitOfMeasure:    'InvoiceUnit'
      MDI.InvoiceQuantity,
      MDI.InvoiceUnit,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      case
      when CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JIS'
      then CGST.AmountInTransactionCurrency + CGST.AmountInTransactionCurrency + MDI.TotalGoodsMvtAmtInCCCrcy
      when IGST.TransactionTypeDetermination = 'JII'
      then IGST.AmountInTransactionCurrency + MDI.TotalGoodsMvtAmtInCCCrcy
      else MDI.TotalGoodsMvtAmtInCCCrcy
      end                                   as InvoiceAmount,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      TDS.AmountInCompanyCodeCurrency       as TDSAmount,
      TDSText.GLAccountName                 as TDSRate,
      case
      when TDS.AmountInCompanyCodeCurrency is not initial and CGST.AmountInTransactionCurrency is not initial and CGST.AmountInTransactionCurrency is not initial and MDI.TotalGoodsMvtAmtInCCCrcy is not initial
      then cast( get_numeric_value(TDS.AmountInCompanyCodeCurrency) + get_numeric_value(CGST.AmountInTransactionCurrency) + get_numeric_value(CGST.AmountInTransactionCurrency) + get_numeric_value(MDI.TotalGoodsMvtAmtInCCCrcy) as abap.dec( 12, 2 ) )
      when TDS.AmountInCompanyCodeCurrency is not initial and IGST.AmountInTransactionCurrency is not initial and MDI.TotalGoodsMvtAmtInCCCrcy is not initial
      then cast( get_numeric_value(TDS.AmountInCompanyCodeCurrency) + get_numeric_value(IGST.AmountInTransactionCurrency) + get_numeric_value(MDI.TotalGoodsMvtAmtInCCCrcy) as abap.dec( 12, 2 ) )
      else null end                         as NetPayable,
      @Semantics.amount.currencyCode:       'SupplierInvoiceCurrencyCode'
      MDI.Amountinlocalcurrency,
      MDI.SupplierInvoiceCurrencyCode,
 //     @Semantics.amount.currencyCode:       'CompanyCodeCurrency1'
//      AICCC.AmountInCompanyCodeCurrency     as AmountInCompanyCodeCurrency,
//      AICCC.CompanyCodeCurrency             as CompanyCodeCurrency1,
        MDI.CompanyCodeCurrency1,
        @Semantics.amount.currencyCode:       'CompanyCodeCurrency1'
        MDI.AmountInCompanyCodeCurrency,
      
  
   
   
      Supplier.Supplier                     as Vendor,
      Text.Country                          as Ctn,
      Text.Language                         as Language,
      Text.Region                           as Region,
      Text.RegionName                       as VendorStateName,
      Supplier.SupplierName                 as VenName,
      Supplier.Region                       as VendorStatecode,
      Supplier.TaxNumber3                   as SupplierGSTNumber,
      Supplier.BusinessPartnerPanNumber     as SupplierPANNumber
      //   @Semantics.amount.currencyCode: 'PriceUnit'
      //   @Aggregation.default: #SUM
      //   ACI.AmountInTransactionCurrency         as Totalamount
      // + ACI.AmountInTransactionCurrency

}
where
      POH.PurchaseOrderType      <> 'ZSTO' //ZSTO for stock transfer
  and POH.PurchaseOrderType      <> 'ZSUB' //ZSUB for sub contracting PO ;
  and POH.PurchaseOrderType      <> 'ZSER'
  and JEH.AccountingDocumentType =  'RE';
