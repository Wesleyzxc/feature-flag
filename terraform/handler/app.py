import json
import logging
import uuid
from typing import Literal, Union

import boto3

logger = logging.getLogger(__name__)
dynamodb = boto3.resource("dynamodb")
MAX_GET_SIZE = 100  # Amazon DynamoDB rejects a get batch larger than 100 items.

## todo: enum of accepted tests? or no tests at all.

def add_feature(feature: str, target: Union[Literal["all"], uuid.UUID]):
    """Add feature to a target (specific account id or all)"""
    logger.info(f"Adding {feature} to {target}")
    table = dynamodb.Table("WesTest")
    table.put_item(
        Item={
            "Feature": feature,
            "Target": target,
        }
    )


def get_feature(feature: str, target: Union[Literal["all"], uuid.UUID]):
    """Get feature of a target"""
    logger.info(f"Getting {feature} for {target} account/s")
    table = dynamodb.Table("WesTest")
    result = table.query(
        KeyConditionExpression="#Feature = :Feature AND #Target = :Target",
        ExpressionAttributeNames={
            "#Target": "Target",
            "#Feature": "Feature",
        },
        ExpressionAttributeValues={
            ":Target": target,
            ":Feature": feature,
        },
    )
    return result


def lambda_handler(event, context):
    """Sample pure Lambda function

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format

        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    API Gateway Lambda Proxy Output Format: dict

        Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    """
    print("-------------------")
    print("event: ", event)
    print("-------------------")

    if event["httpMethod"] == "GET":
        result = get_feature("test", "all")
        return {"statusCode": 200, "body": json.dumps(result)}
    elif event["httpMethod"] == "POST":
        data = json.loads(event["body"])
        add_feature(feature=data["feature"], target=data("target"))
        print(data)
        print(event)
        return {
            "statusCode": 200,
            "body": json.dumps(data),
        }

    return {
        "statusCode": 200,
        "body": json.dumps(event),
    }
