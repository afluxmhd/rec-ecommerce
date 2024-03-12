from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Dict, List
from efficient_apriori import apriori

app = FastAPI()

class Dataset(BaseModel):
    dataset: Dict[str, List[str]]
    support: float
    item_count: int  # Add the item_count to your data model

@app.post("/frequent-items/")
async def get_frequent_items(data: Dataset):
    transactions = list(data.dataset.values())
    support = data.support
    item_count = data.item_count  # Capture the item_count from the request

    if not transactions or support <= 0:
        raise HTTPException(status_code=400, detail="Invalid dataset or support")

    # Execute the Apriori algorithm
    itemsets, _ = apriori(transactions, min_support=support, min_confidence=0.0)

    # Prepare the response
    response = {"Support": support, "Item_count": item_count}
    frequent_items = []

    if item_count in itemsets:
        for items in itemsets[item_count]:
            frequent_items.append(list(items))
    else:
        raise HTTPException(status_code=404, detail=f"No frequent items with {item_count} items found")

    # Adding a dynamic way to populate the response with the frequent items
    for i, items in enumerate(frequent_items, start=1):
        response[str(i)] = items

    return response

