@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZMM_RE
  as select from    I_MaterialDocumentItem_2      as MDI
    inner join      I_MaterialDocumentHeader_2    as MDH      on  MDH.MaterialDocument             = MDI.MaterialDocument
                                                              and MDH.MaterialDocumentYear         = MDI.MaterialDocumentYear
    left outer join I_SuplrInvcItemPurOrdRefAPI01 as Supinv   on  Supinv.PurchaseOrder             = MDI.PurchaseOrder
                                                              and Supinv.PurchaseOrderItem         = MDI.PurchaseOrderItem
                                                              and Supinv.ReferenceDocument         = MDI.MaterialDocument
                                                              and Supinv.FiscalYear                = MDI.MaterialDocumentYear
                                                              and Supinv.PurchaseOrderItemMaterial = MDI.Material
                                                              and Supinv.DebitCreditCode           = 'S'
    left outer join I_SupplierInvoiceAPI01        as Suph     on  Suph.SupplierInvoice             = Supinv.SupplierInvoice
                                                              and Suph.FiscalYear                  = Supinv.FiscalYear
    left outer join I_JournalEntryItem as J_ITM   on J_ITM.ReferenceDocument = Supinv.SupplierInvoice
                                                  and J_ITM.Ledger            = '0L'
                                                  and J_ITM.LedgerGLLineItem  = '000001'
{
 key MDI.PurchaseOrder,
 key MDI.PurchaseOrderItem,
     MDI.MaterialDocumentYear,
     MDI.MaterialDocument,
     MDI.MaterialDocumentItem,
//      PUR_ITEM.PurchaseOrder,
//      PUR_ITEM.PurchaseOrderItem,
      MDI.PostingDate,
      MDI.DebitCreditCode,
      MDI.GoodsMovementType,
      MDI.DocumentDate,
      @Semantics.quantity.unitOfMeasure:    'EntryUnit'
      MDI.QuantityInEntryUnit,
      MDI.EntryUnit,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency'
      MDI.TotalGoodsMvtAmtInCCCrcy,
      MDI.CompanyCodeCurrency,
      MDI.CompanyCode                    as CompanyCode,
      MDI.Material,
      MDI.OrderID,
      MDI.OrderItem,
      MDI.Supplier,
      MDH.ReferenceDocument,
      Supinv.SupplierInvoice             as SupplierInvoiceNo,
      Supinv.SupplierInvoiceItem         as SupplierInvoiceItem,
      Supinv.FiscalYear                  as FiscalYear,
      Suph.DocumentDate                  as InvoiceDate,
      Suph.PostingDate                   as InvoicePostingDate,
      Suph.SupplierInvoiceIDByInvcgParty as InvoiceReference,
      Supinv.DebitCreditCode             as Supplierinvoicedebitcreditcode,
      Supinv.TaxCode                     as Taxcodee,
      @Semantics.quantity.unitOfMeasure:    'InvoiceUnit'
      Supinv.QuantityInPurchaseOrderUnit as InvoiceQuantity,
      Supinv.PurchaseOrderQuantityUnit   as InvoiceUnit,
      @Semantics.amount.currencyCode:       'SupplierInvoiceCurrencyCode'
      Supinv.SupplierInvoiceItemAmount   as Amountinlocalcurrency,
      
      Supinv.DocumentCurrency            as SupplierInvoiceCurrencyCode,
      J_ITM.CompanyCodeCurrency             as CompanyCodeCurrency1,
      @Semantics.amount.currencyCode:       'CompanyCodeCurrency1'
      J_ITM.AmountInCompanyCodeCurrency     as AmountInCompanyCodeCurrency
      
      
}
where
      MDI.GoodsMovementType <> '321'
  and MDI.GoodsMovementType <> '643'
    and MDI.GoodsMovementType <> '541'
  or  MDI.GoodsMovementType =  '101'
  or  MDI.GoodsMovementType =  '102'
  or  MDI.GoodsMovementType =  '122'
  or  MDI.GoodsMovementType =  '161'
