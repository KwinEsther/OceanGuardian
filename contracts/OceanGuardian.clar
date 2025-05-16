;; SupplyChainVerify - End-to-end supply chain verification system
(define-map products uint {
  manufacturer: principal,
  product-name: (string-utf8 64),
  production-process: (string-utf8 256),
  manufacture-date: uint,
  factory-location: (string-utf8 64),
  verified: bool
})
(define-map manufacturer-products principal (list 100 uint))
(define-map inspectors principal bool)
(define-data-var product-id-counter uint u0)
;; Error codes
(define-constant err-not-manufacturer (err u100))
(define-constant err-not-inspector (err u101))
(define-constant err-product-not-found (err u102))
(define-constant err-not-authorized (err u403))
(define-constant err-too-many-products (err u104))
(define-constant err-invalid-principal (err u105))
(define-constant err-invalid-product-name (err u106))
(define-constant err-invalid-process (err u107))
(define-constant err-invalid-date (err u108))
(define-constant err-invalid-location (err u109))
(define-constant err-invalid-product-id (err u110))
;; Contract owner for admin functions
(define-constant contract-owner tx-sender)
;; Add an inspector
(define-public (add-inspector (inspector principal))
  (begin
    ;; Check if sender is contract owner
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
    
    ;; Validate inspector principal
    (asserts! (not (is-eq inspector 'SP000000000000000000002Q6VF78)) err-invalid-principal)
    
    ;; Add inspector to map
    (ok (map-set inspectors inspector true))
  )
)
;; Register a new product
(define-public (register-product 
  (product-name (string-utf8 64)) 
  (production-process (string-utf8 256)) 
  (manufacture-date uint) 
  (factory-location (string-utf8 64)))
  (let
    ((product-id (var-get product-id-counter))
     (manufacturer tx-sender)
     (manufacturer-current-products (default-to (list) (map-get? manufacturer-products manufacturer))))
    
    ;; Validate inputs
    (asserts! (> (len product-name) u0) err-invalid-product-name)
    (asserts! (> (len production-process) u0) err-invalid-process)
    (asserts! (> manufacture-date u0) err-invalid-date)
    (asserts! (> (len factory-location) u0) err-invalid-location)
    
    ;; Check if manufacturer has reached product limit
    (asserts! (< (len manufacturer-current-products) u100) err-too-many-products)
    
    ;; Store the product data
    (map-set products product-id {
      manufacturer: manufacturer,
      product-name: product-name,
      production-process: production-process,
      manufacture-date: manufacture-date,
      factory-location: factory-location,
      verified: false
    })
    
    ;; Create a new list with the product ID
    (let 
      ((new-product-list (unwrap-panic (as-max-len? (concat (list product-id) manufacturer-current-products) u100))))
      ;; Update manufacturer's product list
      (map-set manufacturer-products manufacturer new-product-list)
    )
    
    ;; Increment the product ID counter
    (var-set product-id-counter (+ product-id u1))
    
    (ok product-id)))
;; Verify a product
(define-public (verify-product (product-id uint))
  (begin
    ;; Validate product ID
    (asserts! (< product-id (var-get product-id-counter)) err-invalid-product-id)
    
    (let
      ((product (unwrap! (map-get? products product-id) err-product-not-found)))
      
      ;; Check if sender is an inspector
      (asserts! (default-to false (map-get? inspectors tx-sender)) err-not-inspector)
      
      ;; Update product verification status
      (ok (map-set products product-id (merge product {verified: true})))
    )
  )
)
;; Get product details
(define-read-only (get-product (product-id uint))
  (map-get? products product-id))
;; Get manufacturer's products
(define-read-only (get-manufacturer-products (manufacturer principal))
  (default-to (list) (map-get? manufacturer-products manufacturer)))
;; Check if principal is an inspector
(define-read-only (is-inspector (address principal))
  (default-to false (map-get? inspectors address)))