# OpenSAP - Building Applications on SAP BTP with Microsoft Services - Building Extension Scenarios

This repository contains code samples and step by step instructions 

## Description
Extend productivity beyond SAP ecosystem using MS Teams and Outlook as engagement channels for workflows

Sample project where an employee can create a leave request via chatbot from Microsoft Teams integrated with SAP Conversational AI which triggers an SAP Workflow. The manager of the employee can approve or reject the leave request via a My Inbox app or directly from Microsoft Outlook inbox via Microsoft actionable messages. As soon as the request is approved, a calendar entry will be created in the employee’s Microsoft Outlook triggered via Microsoft Graph APIs

![Solution Architecture](./images/wf-outlook-integration.png)


## Requirements

The required systems and components are:

- SAP Business Technology Platform trial or enterprise account
- Microsoft Azure subscription
- Microsoft 365 developer subscription​

Entitlements/Quota required in your SAP Business Technology Platform Account:

| Service                | Plan             | Nr. of instances |
| ---------------------- | ---------------- | ---------------- |
| Workflow Service       | lite   | 1       |
| Workflow Management    | lite   | 1       |
| Destination            | lite   | 1       |
| Cloud Foundry runtime  | MEMORY | 1       |


Subscriptions required in your SAP Business Technology Platform Account:

| Subscription                    | Plan                      |
| ------------------------------- | ------------------------- |
| SAP Business Application Studio | trial or standard-edition |
| Workflow Management             | saas-application          |


## Units Overview

### [Unit 1: Setting up for Workflow Management on SAP Business Technology Platform](./Unit1/README.md)
### [Unit 2: SAP Workflow Management: create leave request workflow](./Unit2/README.md)
### [Unit 3: Triggering an SAP workflow from an SAP Conversational AI bot](./Unit3/README.md)
### [Unit 4: Sending adaptive cards from an SAP workflow](./Unit4/README.md) 
### [Unit 5: Create calendar entry using Microsoft Graph](./Unit5/README.md)

