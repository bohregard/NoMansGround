using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : Singleton<GameManager>
{

    public GameObject[] players;
    public GameObject[] spawns;

    // Use this for initialization
    void Start()
    {
        Debug.Log("Loading");
        Debug.Log(spawns.Length + " spawns");

        foreach (GameObject item in players)
        {
            System.Random rand = new System.Random();
            var index = rand.Next(spawns.Length);
            item.transform.position = spawns[index].transform.position;
        }
    }

    // Update is called once per frame
    void Update()
    {

    }
}
