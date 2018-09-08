using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : Singleton<GameManager>
{

    public GameObject player1;
    public GameObject player2;

    // Use this for initialization
    void Start()
    {
        Debug.Log("Loading");
    }

    // Update is called once per frame
    void Update()
    {

    }
}
