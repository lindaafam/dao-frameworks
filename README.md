# dao-frameworks

A comprehensive governance infrastructure for building decentralized autonomous organizations on Stacks. Built to give communities the tools they need to make collective decisions, manage treasuries, and coordinate action without centralized control.

## The Governance Problem

Most projects start centralized and struggle to decentralize. Traditional corporate structures don't translate to blockchain communities. You need mechanisms for collective decision-making, treasury management, and coordinated execution that work transparently on-chain. Building these systems from scratch for every project wastes time and introduces security risks through untested code.

## What This Framework Provides

DAO Frameworks gives you production-ready governance primitives:

- **Flexible voting mechanisms** supporting token-weighted, quadratic, and custom models
- **Proposal management** with on-chain discussion and status tracking
- **Treasury controls** using multi-signature security patterns
- **Delegation systems** so token holders can delegate voting power
- **Time-locked execution** preventing rushed governance decisions
- **Emergency veto** mechanisms for critical threat response
- **Analytics dashboards** showing participation and voting patterns
- **Snapshot voting** for gas-free off-chain signaling

## Current Status

**Phase 1: Flexible Voting Mechanisms** ✅

The foundation is operational. A complete voting system supporting multiple voting models including token-weighted (one token = one vote), quadratic voting (reducing whale influence), and simple majority voting. The contract handles proposal creation, vote tallying, threshold checking, and result finalization. Communities can configure voting parameters to match their governance philosophy.

## Installation

### Prerequisites

- Node.js v18 or higher
- Clarinet 3.7.0
- npm or yarn
- Git

### Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/dao-frameworks.git
cd dao-frameworks

# Install dependencies
npm install

# Setup local environment
npm run setup

# Verify installation
clarinet check

# Run tests
npm test
```

## Quick Start

```javascript
import { DAOVoting } from './lib/dao-voting';

// Initialize DAO voting
const dao = new DAOVoting({
  votingPeriod: 1008,  // blocks
  quorum: 40,          // percentage
  threshold: 51        // percentage
});

// Create a proposal
const proposalId = await dao.createProposal({
  title: 'Treasury Allocation for Development',
  description: 'Allocate 100,000 STX for Q1 development',
  votingModel: 'token-weighted'
});

// Cast a vote
await dao.vote({
  proposalId: proposalId,
  support: true,
  votingPower: 1000
});

// Execute passed proposal
await dao.executeProposal(proposalId);
```

## Project Structure

```
dao-frameworks/
├── contracts/
│   ├── dao-voting.clar           # Core voting contract
│   ├── treasury.clar             # Treasury management (coming soon)
│   └── tests/
│       └── voting_test.ts        # Contract tests
├── lib/
│   ├── dao-voting.js             # JavaScript SDK
│   ├── proposal-manager.js       # Proposal utilities
│   └── vote-calculator.js        # Vote tallying logic
├── examples/
│   ├── token-weighted.js         # Token voting example
│   ├── quadratic.js              # Quadratic voting example
│   └── delegation.js             # Delegation example
├── dashboard/
│   └── analytics.js              # Governance analytics
├── tests/
│   └── voting.test.js            # Integration tests
├── Clarinet.toml
├── package.json
└── README.md
```

## Configuration

Configure DAO parameters in `dao.config.js`:

```javascript
module.exports = {
  voting: {
    defaultPeriod: 1008,          // blocks (~7 days)
    minPeriod: 144,               // blocks (~1 day)
    maxPeriod: 4032,              // blocks (~28 days)
    quorumPercentage: 40,         // minimum participation
    thresholdPercentage: 51,      // votes needed to pass
    votingDelay: 144              // blocks before voting starts
  },
  proposals: {
    minTokensToPropose: 1000,     // tokens needed to create proposal
    maxActiveProposals: 10,       // concurrent proposal limit
    discussionPeriod: 288         // blocks before voting
  },
  execution: {
    timeLockPeriod: 288,          // blocks after passing
    gracePeriod: 1008             // blocks to execute
  }
};
```

## Development Roadmap

### Phase 1: Foundation (Current)
- [x] Flexible voting mechanisms
- [ ] Proposal management system
- [ ] Treasury management

### Phase 2: Advanced Features
- [ ] Delegation systems
- [ ] Time-locked execution
- [ ] Emergency veto mechanisms

### Phase 3: Analytics & Optimization
- [ ] Governance analytics
- [ ] Snapshot voting
- [ ] Advanced reporting

## Features in Detail

### Voting Models

**Token-Weighted Voting**
- One token = one vote
- Standard governance model
- Simple and transparent
- Whales have proportional influence

**Quadratic Voting**
- Cost increases quadratically
- Reduces whale dominance
- Encourages broader participation
- More nuanced preference expression

**Simple Majority**
- One address = one vote
- Democratic participation
- Sybil-resistant through other means
- Good for membership DAOs

### Proposal Lifecycle

```
CREATED → DISCUSSION → ACTIVE → PASSED/REJECTED → QUEUED → EXECUTED
                                      ↓
                                   DEFEATED
```

### Governance Parameters

Configurable per DAO:
- Voting period duration
- Quorum requirements
- Approval thresholds
- Proposal creation requirements
- Execution timelock periods

## Running the DAO

```bash
# Start DAO services
npm run start

# Create a proposal
npm run proposal:create

# Check proposal status
npm run proposal:status <id>

# Tally votes
npm run proposal:tally <id>

# Execute proposal
npm run proposal:execute <id>

# View analytics
npm run analytics
```

## API Reference

### DAO Voting Contract

```clarity
;; Create a proposal
(contract-call? .dao-voting create-proposal
  title
  description
  voting-model
  voting-period)

;; Cast a vote
(contract-call? .dao-voting cast-vote
  proposal-id
  support
  voting-power)

;; Finalize voting
(contract-call? .dao-voting finalize-proposal
  proposal-id)

;; Execute proposal
(contract-call? .dao-voting execute-proposal
  proposal-id)

;; Get proposal details
(contract-call? .dao-voting get-proposal
  proposal-id)
```

### JavaScript SDK

```javascript
// Check voting power
const power = await dao.getVotingPower(address);

// Get proposal status
const status = await dao.getProposalStatus(proposalId);

// Calculate voting results
const results = await dao.calculateResults(proposalId);

// Check if proposal passed
const passed = await dao.hasProposalPassed(proposalId);

// Get active proposals
const proposals = await dao.getActiveProposals();
```

## Architecture

The framework operates through coordinated components:

1. **Voting Layer**: Manages vote casting and tallying
2. **Proposal Layer**: Handles proposal lifecycle
3. **Treasury Layer**: Controls fund management
4. **Delegation Layer**: Manages voting power delegation
5. **Execution Layer**: Implements passed proposals
6. **Analytics Layer**: Tracks governance metrics

## Usage Examples

### Creating a Proposal

```javascript
const proposal = await dao.createProposal({
  title: 'Upgrade Protocol Parameters',
  description: 'Increase block reward from 1000 to 1500 tokens',
  votingModel: 'token-weighted',
  votingPeriod: 1008,
  metadata: {
    category: 'protocol-upgrade',
    urgency: 'medium'
  }
});

console.log(`Proposal created: ${proposal.id}`);
```

### Voting on a Proposal

```javascript
// Token-weighted vote
await dao.vote({
  proposalId: 1,
  support: true,
  votingPower: userTokenBalance
});

// Quadratic vote (cost increases quadratically)
await dao.voteQuadratic({
  proposalId: 1,
  support: true,
  votes: 10  // Costs 100 tokens (10^2)
});
```

### Delegating Voting Power

```javascript
// Delegate all voting power
await dao.delegate({
  delegatee: 'SP2C2YFP12AJZB4MABJBAJ55XECVS7E4PMMZ89YZR',
  amount: 5000  // tokens to delegate
});

// Vote as delegatee
await dao.voteWithDelegation({
  proposalId: 1,
  support: true
});

// Revoke delegation
await dao.revokeDelegation({
  delegatee: 'SP2C2YFP12AJZB4MABJBAJ55XECVS7E4PMMZ89YZR'
});
```

### Executing Proposals

```javascript
// Check if proposal passed
const result = await dao.getProposalResult(proposalId);

if (result.passed) {
  // Queue for execution (starts timelock)
  await dao.queueProposal(proposalId);
  
  // Wait for timelock
  await dao.waitForTimelock(proposalId);
  
  // Execute
  await dao.executeProposal(proposalId);
}
```

### Monitoring Governance

```javascript
const analytics = await dao.getAnalytics({
  timeframe: '30d'
});

console.log(`Total proposals: ${analytics.totalProposals}`);
console.log(`Participation rate: ${analytics.participationRate}%`);
console.log(`Average voting power: ${analytics.avgVotingPower}`);
console.log(`Most active voters: ${analytics.topVoters}`);
```

## Security Considerations

### Before Deploying

- Audit all governance parameters carefully
- Test voting mechanisms thoroughly on testnet
- Ensure quorum and threshold values are reasonable
- Have emergency response procedures ready
- Consider starting with higher thresholds

### Best Practices

- Use timelocks for all governance actions
- Implement gradual decentralization
- Monitor for governance attacks
- Keep emergency veto mechanisms
- Document all governance processes clearly

### Common Risks

- **Flash loan attacks**: Timelock voting to prevent same-block manipulation
- **Whale dominance**: Consider quadratic voting or delegation caps
- **Low participation**: Set realistic quorum requirements
- **Rushed decisions**: Implement minimum discussion periods
- **Malicious proposals**: Require minimum tokens to propose

## Governance Models

### Progressive Decentralization

Start conservative, decentralize gradually:

```javascript
// Phase 1: Core team veto
{ quorum: 60, threshold: 75, vetoEnabled: true }

// Phase 2: Reduced thresholds
{ quorum: 50, threshold: 67, vetoEnabled: true }

// Phase 3: Full decentralization
{ quorum: 40, threshold: 51, vetoEnabled: false }
```

### Optimistic Governance

Proposals pass unless vetoed:

```javascript
{
  defaultAction: 'approve',
  vetoThreshold: 20,  // percentage needed to veto
  vetoPeriod: 288     // blocks to veto
}
```

## Testing Strategy

```bash
# Unit tests for voting logic
npm run test:unit

# Integration tests for full lifecycle
npm run test:integration

# Governance attack simulations
npm run test:security

# Load testing for high participation
npm run test:load

# Full test suite
npm test
```

## Analytics Dashboard

Track governance health:
- Proposal submission rates
- Voter participation trends
- Token concentration metrics
- Voting power distribution
- Proposal success rates
- Execution completion rates

## Emergency Procedures

### Emergency Veto

```javascript
// Core team or guardians can veto dangerous proposals
await dao.emergencyVeto({
  proposalId: proposalId,
  reason: 'Security vulnerability identified'
});
```

### Pause Governance

```javascript
// Temporary pause for critical issues
await dao.pauseGovernance({
  duration: 1008,  // blocks
  reason: 'Security audit in progress'
});
```

## Troubleshooting

**Low participation**: Reduce quorum or extend voting period

**Whale dominance**: Implement quadratic voting or voting power caps

**Proposal spam**: Increase minimum tokens required to propose

**Slow execution**: Reduce timelock period if safe

**Governance deadlock**: Implement tie-breaking mechanisms

## Contributing

Help build better governance tools:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/quadratic-voting`)
3. Write comprehensive tests
4. Document governance implications
5. Commit changes (`git commit -m 'Add quadratic voting mechanism'`)
6. Push to branch (`git push origin feature/quadratic-voting`)
7. Open a Pull Request

Governance changes require extra review. Include security analysis.

## Deployment Checklist

- [ ] Audit all contract code
- [ ] Test on testnet for 30+ days
- [ ] Verify all parameters
- [ ] Document governance processes
- [ ] Train core team on emergency procedures
- [ ] Set up monitoring and alerts
- [ ] Deploy with conservative settings
- [ ] Plan gradual decentralization

## License

MIT License - See LICENSE file for details

## Support

Get governance help:
- Open issues on GitHub
- Check /docs for guides
- Review examples directory
- Join community governance discussions

## Acknowledgments

Built with Clarinet 3.7.0 for the Stacks blockchain. Implements governance patterns proven across multiple DAO frameworks and adapted for Clarity's unique capabilities.
