;; DAO Voting Contract
;; Flexible voting mechanisms for decentralized governance

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PROPOSAL-NOT-FOUND (err u101))
(define-constant ERR-VOTING-CLOSED (err u102))
(define-constant ERR-ALREADY-VOTED (err u103))
(define-constant ERR-INVALID-VOTING-POWER (err u104))
(define-constant ERR-INSUFFICIENT-TOKENS (err u105))

(define-map proposals
  { proposal-id: uint }
  {
    proposer: principal,
    title: (string-ascii 256),
    start-height: uint,
    end-height: uint,
    votes-for: uint,
    votes-against: uint,
    executed: bool
  }
)

(define-map voter-records
  { proposal-id: uint, voter: principal }
  {
    support: bool,
    power: uint
  }
)

(define-map token-balances principal uint)

(define-data-var next-proposal-id uint u0)
(define-data-var min-tokens-to-propose uint u1000)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { proposal-id: proposal-id })
)

(define-read-only (get-voting-power (address principal))
  (default-to u0 (map-get? token-balances address))
)

(define-read-only (has-voted (proposal-id uint) (voter principal))
  (is-some (map-get? voter-records { proposal-id: proposal-id, voter: voter }))
)

(define-read-only (get-quadratic-cost (vote-amount uint))
  (* vote-amount vote-amount)
)

(define-public (create-proposal
  (title (string-ascii 256))
  (voting-period uint))
  (let
    (
      (proposal-id (var-get next-proposal-id))
      (proposer-balance (get-voting-power tx-sender))
    )
    (asserts! (>= proposer-balance (var-get min-tokens-to-propose)) ERR-INSUFFICIENT-TOKENS)
    
    (map-set proposals
      { proposal-id: proposal-id }
      {
        proposer: tx-sender,
        title: title,
        start-height: stacks-block-height,
        end-height: (+ stacks-block-height voting-period),
        votes-for: u0,
        votes-against: u0,
        executed: false
      }
    )
    
    (var-set next-proposal-id (+ proposal-id u1))
    (ok proposal-id)
  )
)

(define-public (cast-vote
  (proposal-id uint)
  (support bool)
  (power uint))
  (let
    (
      (proposal (unwrap! (get-proposal proposal-id) ERR-PROPOSAL-NOT-FOUND))
      (voter-balance (get-voting-power tx-sender))
    )
    (asserts! (not (has-voted proposal-id tx-sender)) ERR-ALREADY-VOTED)
    (asserts! (< stacks-block-height (get end-height proposal)) ERR-VOTING-CLOSED)
    (asserts! (<= power voter-balance) ERR-INVALID-VOTING-POWER)
    
    (map-set voter-records
      { proposal-id: proposal-id, voter: tx-sender }
      { support: support, power: power }
    )
    
    (map-set proposals
      { proposal-id: proposal-id }
      (merge proposal {
        votes-for: (if support (+ (get votes-for proposal) power) (get votes-for proposal)),
        votes-against: (if support (get votes-against proposal) (+ (get votes-against proposal) power))
      })
    )
    
    (ok true)
  )
)

(define-public (register-tokens (amount uint))
  (begin
    (map-set token-balances tx-sender amount)
    (ok true)
  )
)