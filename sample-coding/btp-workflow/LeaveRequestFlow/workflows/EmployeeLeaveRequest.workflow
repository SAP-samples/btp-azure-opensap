{
	"contents": {
		"49f5ead5-f089-4a28-9cee-4398eac988f6": {
			"classDefinition": "com.sap.bpm.wfs.Model",
			"id": "EmployeeLeaveRequest",
			"subject": "Leave Request: ${context.reason} by ${context.requestorName}",
			"name": "EmployeeLeaveRequest",
			"documentation": "Leave Request: ${context.reason} by ${context.requestorName}",
			"lastIds": "62d7f4ed-4063-4c44-af8b-39050bd44926",
			"events": {
				"11a9b5ee-17c0-4159-9bbf-454dcfdcd5c3": {
					"name": "Trigger by Teams"
				},
				"2798f4e7-bc42-4fad-a248-159095a2f40a": {
					"name": "End of Workflow"
				}
			},
			"activities": {
				"73f494c7-3a13-4756-b7f7-c56de56f5f8b": {
					"name": "ApproveOrRejectManager"
				},
				"ffe6a394-8168-47c8-93dd-18a39110f40d": {
					"name": "Manager Decision"
				},
				"b0212992-f4f4-400a-b122-da42a6e68c70": {
					"name": "MailTaskAccept"
				},
				"ec715e30-7902-4451-a04b-4e423112b631": {
					"name": "MailTaskDecline"
				}
			},
			"sequenceFlows": {
				"1a3ea684-f23e-4408-ba11-c56f255ce96a": {
					"name": "SequenceFlow2"
				},
				"c4aa3cd5-3859-4915-9d9b-04e187359476": {
					"name": "Declined"
				},
				"82ad9e27-28f4-4077-8d9f-3312dfa92d58": {
					"name": "Accepted"
				},
				"d444fea7-1e6f-4e90-9e5d-9c2e181c781b": {
					"name": "SequenceFlow19"
				},
				"4f29ce80-df31-4d19-ab4f-42c039c4544a": {
					"name": "SequenceFlow21"
				},
				"f49a615c-c855-4a35-ae00-b90de77282b4": {
					"name": "SequenceFlow22"
				}
			},
			"diagrams": {
				"42fa7a2d-c526-4a02-b3ba-49b5168ba644": {}
			}
		},
		"11a9b5ee-17c0-4159-9bbf-454dcfdcd5c3": {
			"classDefinition": "com.sap.bpm.wfs.StartEvent",
			"id": "startevent1",
			"name": "Trigger by Teams",
			"sampleContextRefs": {
				"c44cbcb3-90bf-4bb5-9ff8-6eb30efe1e0e": {}
			}
		},
		"2798f4e7-bc42-4fad-a248-159095a2f40a": {
			"classDefinition": "com.sap.bpm.wfs.EndEvent",
			"id": "endevent1",
			"name": "End of Workflow"
		},
		"73f494c7-3a13-4756-b7f7-c56de56f5f8b": {
			"classDefinition": "com.sap.bpm.wfs.UserTask",
			"subject": "Leave Request: ${context.reason} by ${context.requestorName}",
			"description": "This workflow was triggered by ${context.requestor} via a Microsoft Teams bot",
			"priority": "MEDIUM",
			"isHiddenInLogForParticipant": false,
			"supportsForward": false,
			"userInterface": "sapui5://comsapbpmworkflow.comsapbpmwusformplayer/com.sap.bpm.wus.form.player",
			"recipientUsers": "${context.requestor}",
			"formReference": "/forms/EmployeeLeaveRequest/ManagerApproval.form",
			"userInterfaceParams": [{
				"key": "formId",
				"value": "ManagerApproval"
			}, {
				"key": "formRevision",
				"value": "1.0"
			}],
			"id": "usertask1",
			"name": "ApproveOrRejectManager",
			"documentation": "Manager should Approve or Reject Leave Request"
		},
		"ffe6a394-8168-47c8-93dd-18a39110f40d": {
			"classDefinition": "com.sap.bpm.wfs.ExclusiveGateway",
			"id": "exclusivegateway4",
			"name": "Manager Decision",
			"default": "82ad9e27-28f4-4077-8d9f-3312dfa92d58"
		},
		"b0212992-f4f4-400a-b122-da42a6e68c70": {
			"classDefinition": "com.sap.bpm.wfs.MailTask",
			"id": "mailtask2",
			"name": "MailTaskAccept",
			"mailDefinitionRef": "2961ea19-4e7c-4334-b72f-29b60b8cadca"
		},
		"ec715e30-7902-4451-a04b-4e423112b631": {
			"classDefinition": "com.sap.bpm.wfs.MailTask",
			"id": "mailtask3",
			"name": "MailTaskDecline",
			"mailDefinitionRef": "f23e3e6f-a47b-43e9-b00f-332d841be173"
		},
		"1a3ea684-f23e-4408-ba11-c56f255ce96a": {
			"classDefinition": "com.sap.bpm.wfs.SequenceFlow",
			"id": "sequenceflow2",
			"name": "SequenceFlow2",
			"sourceRef": "11a9b5ee-17c0-4159-9bbf-454dcfdcd5c3",
			"targetRef": "73f494c7-3a13-4756-b7f7-c56de56f5f8b"
		},
		"c4aa3cd5-3859-4915-9d9b-04e187359476": {
			"classDefinition": "com.sap.bpm.wfs.SequenceFlow",
			"condition": "${usertasks.usertask1.last.decision == \"decline\"}",
			"id": "sequenceflow10",
			"name": "Declined",
			"documentation": "Manager has declined the Leave Request",
			"sourceRef": "ffe6a394-8168-47c8-93dd-18a39110f40d",
			"targetRef": "ec715e30-7902-4451-a04b-4e423112b631"
		},
		"82ad9e27-28f4-4077-8d9f-3312dfa92d58": {
			"classDefinition": "com.sap.bpm.wfs.SequenceFlow",
			"id": "sequenceflow11",
			"name": "Accepted",
			"documentation": "Manager has accepted the Leave Request",
			"sourceRef": "ffe6a394-8168-47c8-93dd-18a39110f40d",
			"targetRef": "b0212992-f4f4-400a-b122-da42a6e68c70"
		},
		"d444fea7-1e6f-4e90-9e5d-9c2e181c781b": {
			"classDefinition": "com.sap.bpm.wfs.SequenceFlow",
			"id": "sequenceflow19",
			"name": "SequenceFlow19",
			"sourceRef": "73f494c7-3a13-4756-b7f7-c56de56f5f8b",
			"targetRef": "ffe6a394-8168-47c8-93dd-18a39110f40d"
		},
		"4f29ce80-df31-4d19-ab4f-42c039c4544a": {
			"classDefinition": "com.sap.bpm.wfs.SequenceFlow",
			"id": "sequenceflow21",
			"name": "SequenceFlow21",
			"sourceRef": "b0212992-f4f4-400a-b122-da42a6e68c70",
			"targetRef": "2798f4e7-bc42-4fad-a248-159095a2f40a"
		},
		"f49a615c-c855-4a35-ae00-b90de77282b4": {
			"classDefinition": "com.sap.bpm.wfs.SequenceFlow",
			"id": "sequenceflow22",
			"name": "SequenceFlow22",
			"sourceRef": "ec715e30-7902-4451-a04b-4e423112b631",
			"targetRef": "2798f4e7-bc42-4fad-a248-159095a2f40a"
		},
		"42fa7a2d-c526-4a02-b3ba-49b5168ba644": {
			"classDefinition": "com.sap.bpm.wfs.ui.Diagram",
			"symbols": {
				"df898b52-91e1-4778-baad-2ad9a261d30e": {},
				"53e54950-7757-4161-82c9-afa7e86cff2c": {},
				"3ebddfc1-5bf0-40d9-8d83-c6528557b242": {},
				"a9168b48-ec53-44e2-a82c-fc7518574cb3": {},
				"756cf9e7-811d-4171-b784-3845e79a5e1d": {},
				"d4ea8757-e6c8-46f9-a9cc-4cf2613d2282": {},
				"4df6c936-dc35-4126-80d0-1e9b2c9b6fb4": {},
				"14708241-ef20-4419-b4d3-827d70212a89": {},
				"60989c28-30a8-49f6-aa98-1cdcfbae6ab0": {},
				"03f11ead-0db0-4e0e-a402-685374848be0": {},
				"a62cc9da-9df0-4e18-bbec-a5c580ccdd91": {},
				"45a98488-614a-433b-8b98-c6a321aa28ab": {}
			}
		},
		"c44cbcb3-90bf-4bb5-9ff8-6eb30efe1e0e": {
			"classDefinition": "com.sap.bpm.wfs.SampleContext",
			"reference": "/sample-data/EmployeeLeaveRequest/sampleContext.json",
			"id": "default-start-context"
		},
		"df898b52-91e1-4778-baad-2ad9a261d30e": {
			"classDefinition": "com.sap.bpm.wfs.ui.StartEventSymbol",
			"x": 12,
			"y": 81,
			"width": 32,
			"height": 32,
			"object": "11a9b5ee-17c0-4159-9bbf-454dcfdcd5c3"
		},
		"53e54950-7757-4161-82c9-afa7e86cff2c": {
			"classDefinition": "com.sap.bpm.wfs.ui.EndEventSymbol",
			"x": 525.9999976158142,
			"y": 79.5,
			"width": 35,
			"height": 35,
			"object": "2798f4e7-bc42-4fad-a248-159095a2f40a"
		},
		"3ebddfc1-5bf0-40d9-8d83-c6528557b242": {
			"classDefinition": "com.sap.bpm.wfs.ui.UserTaskSymbol",
			"x": 94,
			"y": 67,
			"width": 100,
			"height": 60,
			"object": "73f494c7-3a13-4756-b7f7-c56de56f5f8b"
		},
		"a9168b48-ec53-44e2-a82c-fc7518574cb3": {
			"classDefinition": "com.sap.bpm.wfs.ui.SequenceFlowSymbol",
			"points": "44,97 94,97",
			"sourceSymbol": "df898b52-91e1-4778-baad-2ad9a261d30e",
			"targetSymbol": "3ebddfc1-5bf0-40d9-8d83-c6528557b242",
			"object": "1a3ea684-f23e-4408-ba11-c56f255ce96a"
		},
		"756cf9e7-811d-4171-b784-3845e79a5e1d": {
			"classDefinition": "com.sap.bpm.wfs.ui.ExclusiveGatewaySymbol",
			"x": 244,
			"y": 76,
			"object": "ffe6a394-8168-47c8-93dd-18a39110f40d"
		},
		"d4ea8757-e6c8-46f9-a9cc-4cf2613d2282": {
			"classDefinition": "com.sap.bpm.wfs.ui.SequenceFlowSymbol",
			"points": "286,97 320.99999940395355,97 320.99999940395355,42 355.9999988079071,42",
			"sourceSymbol": "756cf9e7-811d-4171-b784-3845e79a5e1d",
			"targetSymbol": "a62cc9da-9df0-4e18-bbec-a5c580ccdd91",
			"object": "c4aa3cd5-3859-4915-9d9b-04e187359476"
		},
		"4df6c936-dc35-4126-80d0-1e9b2c9b6fb4": {
			"classDefinition": "com.sap.bpm.wfs.ui.SequenceFlowSymbol",
			"points": "286,97 320.99999940395355,97 320.99999940395355,152 355.9999988079071,152",
			"sourceSymbol": "756cf9e7-811d-4171-b784-3845e79a5e1d",
			"targetSymbol": "60989c28-30a8-49f6-aa98-1cdcfbae6ab0",
			"object": "82ad9e27-28f4-4077-8d9f-3312dfa92d58"
		},
		"14708241-ef20-4419-b4d3-827d70212a89": {
			"classDefinition": "com.sap.bpm.wfs.ui.SequenceFlowSymbol",
			"points": "194,97 244,97",
			"sourceSymbol": "3ebddfc1-5bf0-40d9-8d83-c6528557b242",
			"targetSymbol": "756cf9e7-811d-4171-b784-3845e79a5e1d",
			"object": "d444fea7-1e6f-4e90-9e5d-9c2e181c781b"
		},
		"60989c28-30a8-49f6-aa98-1cdcfbae6ab0": {
			"classDefinition": "com.sap.bpm.wfs.ui.MailTaskSymbol",
			"x": 355.9999988079071,
			"y": 122,
			"width": 100,
			"height": 60,
			"object": "b0212992-f4f4-400a-b122-da42a6e68c70"
		},
		"03f11ead-0db0-4e0e-a402-685374848be0": {
			"classDefinition": "com.sap.bpm.wfs.ui.SequenceFlowSymbol",
			"points": "455.9999988079071,152 490.99999821186066,152 490.99999821186066,97 525.9999976158142,97",
			"sourceSymbol": "60989c28-30a8-49f6-aa98-1cdcfbae6ab0",
			"targetSymbol": "53e54950-7757-4161-82c9-afa7e86cff2c",
			"object": "4f29ce80-df31-4d19-ab4f-42c039c4544a"
		},
		"a62cc9da-9df0-4e18-bbec-a5c580ccdd91": {
			"classDefinition": "com.sap.bpm.wfs.ui.MailTaskSymbol",
			"x": 355.9999988079071,
			"y": 12,
			"width": 100,
			"height": 60,
			"object": "ec715e30-7902-4451-a04b-4e423112b631"
		},
		"45a98488-614a-433b-8b98-c6a321aa28ab": {
			"classDefinition": "com.sap.bpm.wfs.ui.SequenceFlowSymbol",
			"points": "455.9999988079071,42 490.99999821186066,42 490.99999821186066,97 525.9999976158142,97",
			"sourceSymbol": "a62cc9da-9df0-4e18-bbec-a5c580ccdd91",
			"targetSymbol": "53e54950-7757-4161-82c9-afa7e86cff2c",
			"object": "f49a615c-c855-4a35-ae00-b90de77282b4"
		},
		"62d7f4ed-4063-4c44-af8b-39050bd44926": {
			"classDefinition": "com.sap.bpm.wfs.LastIDs",
			"maildefinition": 3,
			"hubapireference": 2,
			"sequenceflow": 22,
			"startevent": 1,
			"endevent": 1,
			"usertask": 2,
			"servicetask": 2,
			"scripttask": 3,
			"mailtask": 3,
			"exclusivegateway": 4,
			"parallelgateway": 1
		},
		"2961ea19-4e7c-4334-b72f-29b60b8cadca": {
			"classDefinition": "com.sap.bpm.wfs.MailDefinition",
			"name": "maildefinition2",
			"to": " ${context.requestor} ",
			"subject": "Leave Request: ${context.reason} approved",
			"text": "Leave Request: ${context.reason} was approved by your manager ",
			"id": "maildefinition2"
		},
		"f23e3e6f-a47b-43e9-b00f-332d841be173": {
			"classDefinition": "com.sap.bpm.wfs.MailDefinition",
			"name": "maildefinition3",
			"to": " ${context.requestor} ",
			"subject": "Leave Request: ${context.reason} declined",
			"text": "Leave Request: ${context.reason} was declined by your manager ",
			"id": "maildefinition3"
		}
	}
}