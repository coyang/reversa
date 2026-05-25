# Template for a Gherkin scenario in parity_tests/.
# Each file must cover a critical flow identified in the legacy process_flows.
# Adapt criteria to the target paradigm per `parity_specs.md`.

# language: en
# spec-id: PT-001
# traceability:
#   process_flows: <ref to the flow in _reversa_sdd>
#   target_architecture: <ref to component in target_architecture.md>
#   target_paradigm: <from paradigm_decision.md>

Feature: <Flow name>
  As <actor>
  I want <action>
  So that <goal>

  # General parity criterion applied to this scenario.
  # When the target paradigm is event-driven, express the eventual-consistency tolerance here.
  @parity @critical
  Scenario: <description>
    Given <observable precondition>
    And <secondary precondition>
    When <action executed via API / command / input event>
    Then <observable effect in the new system>
    And <observable effect persists after <propagation window>>

  # Specific scenario to validate idempotency (event-driven, safe retry).
  @parity @idempotency
  Scenario: Reprocessing does not duplicate the effect
    Given <precondition>
    When <action> is processed once
    And <action> is redelivered by retry
    Then the observable effect is identical to the first delivery

  # Specific scenario to validate order in an event-driven paradigm.
  @parity @order
  Scenario: Event order is respected per key
    Given <partitioning key>
    When <event A> is published before <event B> with the same key
    Then <observable effect> reflects the A → B order
